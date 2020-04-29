import GitHub
import Bow
import BowArch
import BowOptics
import SwiftUI

typealias AppComponent<Catalog: View, Search: View, Detail: View> = StoreComponent<API.Config, AppState, AppAction, AppView<Catalog, Search, Detail>>
typealias CatalogChild = StoreComponent<API.Config, AppState, AppAction, RecipeCatalogView>
typealias SearchChild = StoreComponent<API.Config, AppState, AppAction, SearchView>
typealias DetailChild = StoreComponent<API.Config, AppState, RepositoryDetailAction, RepositoryDetailView>

func appComponent() -> AppComponent<CatalogChild, SearchChild, DetailChild> {
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
                      transformInput: AppAction.catalogPrism)
                .using(dispatcher: appDispatcher.lift(id), handler: handler),
            
            search: searchComponent(config: config, state: state.searchState)
                .lift(
                    initialState: state,
                    environment: config,
                    transformEnvironment: id,
                    transformState: AppState.searchStateLens,
                    transformInput: AppAction.searchPrism)
                .using(dispatcher: appDispatcher.lift(id),
                       handler: handler),
            
            detail: { repository in
                repositoryDetail(config: config, state: repository)
                .lift(
                    initialState: state,
                    environment: config,
                    transformEnvironment: id,
                    transformState: AppState.modalStateLens,
                    transformInput: Prism.identity)
                .using(dispatcher: StateDispatcher.empty(), handler: handler)
            },
            handle: handle)
    }
}
