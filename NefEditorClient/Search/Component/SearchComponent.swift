import GitHub
import Bow
import BowArch

typealias SearchComponent = StoreComponent<SearchState, SearchView>

func searchComponent(config: API.Config) -> SearchComponent {
    SearchComponent(
        initialState: SearchState(loadingState: .initial, modalState: .noModal),
        environment: config) { state, handler in
            
        SearchView(
            state: state,
            detail: config |> repositoryDetail,
            handle: searchDispatcher.sendingTo(handler, environment: config))
    }
}
