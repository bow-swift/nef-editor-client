import GitHub
import Bow
import BowArch
import BowOptics
import SwiftUI

typealias AppComponent<V: View> = StoreComponent<API.Config, AppState, AppAction, AppView<V>>

func appComponent() -> AppComponent<SearchComponent> {
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
    ) { state, handle in
        AppView(
            state: state,
            search: searchComponent(config: config, state: state.searchState),
            handle: handle)
    }
}
