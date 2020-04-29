import GitHub
import Bow
import BowArch
import BowOptics
import SwiftUI

typealias AppComponent<Catalog: View, Search: View, Edit: View> = StoreComponent<API.Config, AppState, AppAction, AppView<Catalog, Search, Edit>>
typealias CatalogChild = StoreComponent<API.Config, AppState, AppAction, RecipeCatalogView>
typealias SearchChild = StoreComponent<API.Config, AppState, AppAction, SearchView<SearchDetailChild>>
typealias EditChild = StoreComponent<API.Config, AppState, AppAction, EditRecipeMetadataView>

func appComponent() -> AppComponent<CatalogChild, SearchChild, EditChild> {
    let initialState = AppState(
        panelState: .catalog,
        editState: .notEditing,
        searchState: SearchState(loadingState: .initial, modalState: .noModal),
        catalog: Catalog.initial,
        selectedItem: Catalog.initialSelection)
    let config = API.Config(basePath: "https://api.github.com")
    
    return AppComponent(
        initialState: initialState,
        environment: config,
        dispatcher: appDispatcher.lift(id)
    ) { state, handle, handler in
        AppView(
            state: state,
            
            catalog: catalogComponent(state: state.catalog)
                .lift(initialState: state,
                      environment: config,
                      transformEnvironment: id,
                      transformState: AppState.catalogLens,
                      transformInput: AppAction.prism(for: AppAction.catalogAction))
                .using(dispatcher: appDispatcher.lift(id), handler: handler),
            
            search: searchComponent(config: config, state: state.searchState)
                .lift(
                    initialState: state,
                    environment: config,
                    transformEnvironment: id,
                    transformState: AppState.searchStateLens,
                    transformInput: AppAction.prism(for: AppAction.searchAction))
                .using(dispatcher: appDispatcher.lift(id),
                       handler: handler),
            
            edit: editComponent(state: state.editState)
                .lift(initialState: state,
                      environment: config,
                      transformEnvironment: id,
                      transformState: AppState.editStateLens,
                      transformInput: AppAction.prism(for: AppAction.editAction))
                .using(dispatcher: appDispatcher.lift(id),
                       handler: handler),
            
            handle: handle)
    }
}
