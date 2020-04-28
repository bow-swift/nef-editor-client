import GitHub
import BowArch

typealias RepositoryDetailComponent = StoreComponent<API.Config, RepositoryDetailState, RepositoryDetailAction, RepositoryDetailView>

func repositoryDetail(
    config: API.Config,
    repository: Repository
) -> RepositoryDetailComponent {
    
    RepositoryDetailComponent(
        initialState: RepositoryDetailState.loading(repository),
        environment: config,
        dispatcher: repositoryDetailDispatcher,
        render: RepositoryDetailView.init)
}
