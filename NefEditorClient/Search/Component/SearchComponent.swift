import GitHub
import Bow
import BowArch

typealias SearchComponent = StoreComponent<API.Config, SearchState, SearchAction, SearchView<SearchDetailChild>>
typealias SearchDetailChild = StoreComponent<API.Config, SearchState, SearchAction, RepositoryDetailView>

func searchComponent(
    config: API.Config,
    state: SearchState
) -> SearchComponent {
    SearchComponent(
        initialState: state,
        environment: config,
        dispatcher: searchDispatcher) { state, handle, handler in
            SearchView(
                state: state,
                detail: repositoryDetail(config: config, state: state.modalState)
                    .lift(
                        initialState: state,
                        environment: config,
                        transformEnvironment: id,
                        transformState: SearchState.modalStateLens,
                        transformInput: SearchAction.prism(for: SearchAction.repositoryDetailAction))
                    .using(dispatcher: .empty(), handler: handler),
                handle: handle
            )
    }
}
