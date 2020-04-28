import GitHub
import Bow
import BowArch
import BowOptics
import SwiftUI

typealias AppComponent<Search: View, Detail: View> = StoreComponent<API.Config, AppState, AppAction, AppView<Search, Detail>>
typealias SearchChild = StoreComponent<API.Config, AppState, AppAction, SearchView>
typealias DetailChild = StoreComponent<API.Config, AppState, RepositoryDetailAction, RepositoryDetailView>

func appComponent() -> AppComponent<SearchChild, DetailChild> {
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
            search: searchComponent(config: config, state: state.searchState)
                .lift(
                    initialState: state,
                    environment: config,
                    id, AppState.searchStateLens, prism)
                .using(dispatcher: appDispatcher.lift(id),
                       handler: handler),
            detail: { repository in
                repositoryDetail(config: config, state: repository)
                .lift(
                    initialState: state,
                    environment: config,
                    id,
                    AppState.modalStateLens,
                    Prism.identity)
                .using(dispatcher: StateDispatcher.empty(), handler: handler)
            },
            handle: handle)
    }
}

let prism: Prism<AppAction, SearchAction> = Prism(
    extract: { app in
        guard case let .searchAction(action) = app else {
            return nil
        }
        return action
    },
    embed: AppAction.searchAction
)
