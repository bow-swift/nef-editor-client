import GitHub
import Bow
import BowArch
import BowOptics
import SwiftUI

typealias AppComponent<Catalog: View, Search: View, Detail: View, Edit: View> = StoreComponent<API.Config, AppState, AppAction, AppView<Catalog, Search, Detail, Edit>>

typealias CatalogChild = StoreComponent<API.Config, AppState, AppAction, RecipeCatalogView>
typealias SearchChild = StoreComponent<API.Config, AppState, AppAction, SearchView<SearchDetailChild>>
typealias DetailChild = StoreComponent<API.Config, AppState, AppAction, CatalogItemDetailView>
typealias EditChild = StoreComponent<API.Config, AppState, AppAction, EditRecipeMetadataView>

func appComponent() -> AppComponent<CatalogChild, SearchChild, DetailChild, EditChild> {
    let initialState = AppState(
        panelState: .catalog,
        editState: .notEditing,
        searchState: SearchState(loadingState: .initial, modalState: .noModal),
        catalog: Catalog.initial,
        selectedItem: Catalog.initialSelection)
    let config = API.Config(basePath: "https://api.github.com")
    let mainDispatcher: StateDispatcher<API.Config, AppState, AppAction> = appDispatcher.lift(id)
    
    return AppComponent(
        initialState: initialState,
        environment: config,
        dispatcher: mainDispatcher
    ) { state, handle, handler in
        AppView(
            state: state,
            
            catalog: catalogComponent(state: state.catalog)
                .lift(initialState: state,
                      environment: config,
                      transformEnvironment: id,
                      transformState: AppState.catalogLens,
                      transformInput: AppAction.prism(for: AppAction.catalogAction))
                .using(dispatcher: mainDispatcher,
                       handler: handler),
            
            search: searchComponent(config: config, state: state.searchState)
                .lift(
                    initialState: state,
                    environment: config,
                    transformEnvironment: id,
                    transformState: AppState.searchStateLens,
                    transformInput: AppAction.prism(for: AppAction.searchAction))
                .using(dispatcher: mainDispatcher,
                       handler: handler),
            
            detail: catalogDetailComponent(state: state.selectedItem)
                .lift(initialState: state,
                      environment: config,
                      transformEnvironment: id,
                      transformState: AppState.selectedItemLens,
                      transformInput: AppAction.prism(for: AppAction.catalogDetailAction))
                .using(dispatcher: mainDispatcher,
                       handler: handler),
            
            edit: editComponent(state: state.editState)
                .lift(initialState: state,
                      environment: config,
                      transformEnvironment: id,
                      transformState: AppState.editStateLens,
                      transformInput: AppAction.prism(for: AppAction.editAction))
                .using(dispatcher: mainDispatcher,
                       handler: handler),
            
            handle: handle)
    }
}
