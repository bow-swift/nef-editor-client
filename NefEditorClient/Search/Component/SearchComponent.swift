import GitHub
import Bow
import BowArch

typealias SearchComponent = StoreComponent<API.Config, SearchState, SearchAction, SearchView>

func searchComponent(
    config: API.Config,
    state: SearchState
) -> SearchComponent {
    SearchComponent(
        initialState: state,
        environment: config,
        dispatcher: searchDispatcher) { state, handle in
        SearchView(
            state: state,
            detail: config |> repositoryDetail,
            handle: handle)
    }
}
