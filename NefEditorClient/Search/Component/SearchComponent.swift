import GitHub
import Bow
import BowArch

typealias SearchComponent = StoreComponent<API.Config, SearchState, SearchAction, SearchView<RepositoryDetailComponent>>

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
                detail: repositoryDetail(config: config, state: state.modalState)
                    .using(handle, transformInput: SearchAction.prism(for: SearchAction.repositoryDetailAction)),
                handle: handle
            )
    }
}
