import GitHub
import Bow
import BowArch
import BowOptics
import SwiftUI

typealias AppComponent<V: View> = StoreComponent<API.Config, AppState, AppAction, AppView<V>>
typealias SearchChild = StoreComponent<API.Config, AppState, AppAction, SearchView>

func appComponent() -> AppComponent<SearchChild> {
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
                    id, lens, prism)
                .using(dispatcher: appDispatcher.lift(id),
                       handler: handler),
            handle: handle)
    }
}

let lens: Lens<AppState, SearchState> = Lens(
    get: { app in app.searchState },
    set: { app, search in app.copy(searchState: search) }
)

let prism: Prism<AppAction, SearchAction> = Prism(
    extract: { app in
        guard case let .searchAction(action) = app else {
            return nil
        }
        return action
    },
    embed: AppAction.searchAction
)
