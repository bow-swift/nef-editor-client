import GitHub
import BowArch

typealias SearchComponent = StoreComponent<SearchState, SearchView>

func searchComponent(config: API.Config) -> SearchComponent {
    SearchComponent(
        initialState: .initial,
        environment: config) { state, handler in
            
        SearchView(
            state: state,
            handle: searchDispatcher.sendingTo(handler, environment: config))
    }
}
