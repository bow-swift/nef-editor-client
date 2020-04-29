import GitHub
import BowArch

typealias RepositoryDetailComponent = StoreComponent<API.Config, SearchModalState, RepositoryDetailAction, RepositoryDetailView>

func repositoryDetail(
    config: API.Config,
    state: SearchModalState
) -> RepositoryDetailComponent {
    
    RepositoryDetailComponent(
        initialState: state,
        environment: config,
        dispatcher: repositoryDetailDispatcher,
        render: RepositoryDetailView.init)
}
