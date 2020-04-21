import GitHub
import BowArch

typealias AppComponent = StoreComponent<AppState, AppView>

func appComponent() -> AppComponent {
    let initialState = AppState(
        panelState: .catalog,
        editState: .notEditing,
        catalog: Catalog.initial,
        selectedItem: .regular(sampleRecipe))
    let config = API.Config(basePath: "https://api.github.com")
    let search = searchComponent(config: config)
    
    return AppComponent(initialState: initialState) { state, handler in
        AppView(
            state: state,
            search: search,
            handle: appDispatcher.sendingTo(handler))
    }
}
