import GitHub
import Bow
import BowArch
import BowOptics
import BowEffects
import SwiftUI

typealias AppComponent<Catalog: View, Search: View, Detail: View, Edit: View> = StoreComponent<AppDependencies, AppState, AppAction, AppView<Catalog, Search, Detail, Edit>>

func appComponent() -> AppComponent<CatalogComponent, SearchComponent, CatalogDetailComponent, EditComponent> {
    let initialState = AppState(
        panelState: .catalog,
        editState: .notEditing,
        searchState: SearchState(loadingState: .initial, modalState: .noModal),
        catalog: Catalog.initial,
        selectedItem: nil,
        iCloudStatus: .enabled,
        iCloudAlert: .hidden)
    let config = API.Config(basePath: "https://api.github.com")
    let persistence = ICloudPersistence()
    let dependencies = AppDependencies(persistence: persistence, config: config)
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
            
            search: searchComponent(config: config, state: state.searchState)
                .using(handle, transformInput: AppAction.prism(for: AppAction.searchAction)),
            
            detail: catalogDetailComponent(state: state.selectedItem)
                .using(handle, transformInput: AppAction.prism(for: AppAction.catalogDetailAction)),
            
            edit: editComponent(state: state.editState)
                .using(handle, transformInput: AppAction.prism(for: AppAction.editAction)),
            
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
