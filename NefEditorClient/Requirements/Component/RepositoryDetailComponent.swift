import GitHub
import BowArch

typealias RepositoryDetailComponent = StoreComponent<RepositoryDetailState, RepositoryDetailView>

func repositoryDetail(config: API.Config, repository: Repository) -> RepositoryDetailComponent {
    RepositoryDetailComponent(
        initialState: RepositoryDetailState.loading(repository),
        environment: config) { state, handler in
            RepositoryDetailView(
                state: state,
                handle: repositoryDetailDispatcher.sendingTo(handler, environment: config))
    }
}
