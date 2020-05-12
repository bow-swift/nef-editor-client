import GitHub
import NefAPI
import Bow
import BowArch
import BowOptics
import BowEffects
import SwiftUI

typealias AppComponent<Catalog: View, Search: View, Detail: View, Edit: View, Generation: View, Credits: View> =
    StoreComponent<
        AppDependencies,
        AppState,
        AppAction,
        AppView<Catalog, Search, Detail, Edit, Generation, Credits>
    >

func appComponent() -> AppComponent<CatalogComponent, SearchComponent, CatalogDetailComponent, EditComponent, GenerationComponent, CreditsComponent> {
    let initialState = AppState(
        panelState: .catalog,
        editState: .notEditing,
        searchState: SearchState(loadingState: .initial, modalState: .noModal),
        catalog: Catalog.initial,
        selectedItem: nil,
        iCloudStatus: .enabled,
        iCloudAlert: .hidden,
        creditsModal: .hidden,
        authenticationState: .unauthenticated,
        generationState: .notGenerating)
    let gitHubConfig = GitHub.API.Config(basePath: "https://api.github.com")
    let nefConfig = NefAPI.API.Config(basePath: "https://nef.miguelangel.me/")
        .appending(contentType: .json)
    let persistence = ICloudPersistence()
    let dependencies = AppDependencies(
        persistence: persistence,
        gitHubConfig: gitHubConfig,
        nefConfig: nefConfig)
    let ref = IORef<Error, [Recipe]?>.unsafe(nil)
    
    return AppComponent(
        initialState: initialState,
        environment: dependencies,
        dispatcher: appDispatcher
    ) { state, handle in
        AppView(
            state: state,
            
            catalog: catalogComponent(catalog: state.catalog, selectedItem: state.selectedItem)
                .using(handle, transformInput: AppAction.prism(for: AppAction.catalogAction)),
            
            search: searchComponent(config: gitHubConfig, state: state.searchState)
                .using(handle, transformInput: AppAction.prism(for: AppAction.searchAction)),
            
            detail: { item in
                catalogDetailComponent(state: item)
                    .using(handle, transformInput: AppAction.prism(for: AppAction.catalogDetailAction))
            },
            
            edit: editComponent(state: state.editState)
                .using(handle, transformInput: AppAction.prism(for: AppAction.editAction)),
            
            generation: { state in
                generationComponent(state: state)
                    .using(handle, transformInput: AppAction.prism(for: AppAction.generationAction))
            },
            
            credits: creditsComponent()
                .using(handle, transformInput: AppAction.prism(for: AppAction.creditsAction)),
            
            handle: handle)
    }.onEffect { component in
        let oldRecipes = IO<Error, [Recipe]?>.var()
        let newRecipes = component.store().state.catalog.userCreated.items.map(\.recipe)
        
        return binding(
            oldRecipes <- ref.get(),
            |<-((oldRecipes.get != newRecipes) ?
                persist(state: component.store().state).provide(persistence) :
                IO.lazy()),
            |<-ref.set(newRecipes),
            yield: ())
    }
}
