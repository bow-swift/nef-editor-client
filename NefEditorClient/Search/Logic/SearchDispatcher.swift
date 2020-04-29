import GitHub
import Bow
import BowArch
import BowEffects

typealias SearchDispatcher = StateDispatcher<API.Config, SearchState, SearchAction>

let searchDispatcher = SearchDispatcher.workflow { action in
    switch action {
        
    case .search(query: let query):
        return search(query: query)
            
    case .showDetails(let repository):
        return [EnvIO.pure(showDetails(repository))^]
        
    case .dismissDetails:
        return [EnvIO.pure(dismissDetails())^]
        
    case .cancelSearch, .repositoryDetailAction(_):
        return [EnvIO.pure(.modify(id)^)^]
    }
}

func search(
    query: String
) -> [EnvIO<API.Config, Error, State<SearchState, Void>>] {
    [
        EnvIO.pure(setLoading(query: query))^,
        backgroundSearch(query: query).handleError { _ in
            onError(query: query)
        }^
    ]
}

func setLoading(query: String) -> State<SearchState, Void> {
    .modify { state in
        state.copy(loadingState: .loading(query: query))
    }^
}

func backgroundSearch(query: String) -> EnvIO<API.Config, Error, State<SearchState, Void>> {
    let repositories = EnvIO<API.Config, Error, Repositories>.var()
    
    return binding(
        continueOn(.global(qos: .background)),
        repositories <- gitHubSearch(query: query),
        yield: showResults(repositories: repositories.get, for: query)
    )^
}

func gitHubSearch(
    query: String
) -> EnvIO<API.Config, Error, Repositories> {
    API.search.searchRepositories(q: "\(query)+language:Swift" )
        .bimap(id, { result in result.items })
}

func showResults(repositories: Repositories, for query: String) -> State<SearchState, Void> {
    .modify { state in
        let newState: SearchLoadingState = (repositories.isEmpty)
            ? .empty(query: query)
            : .loaded(repositories)
        return state.copy(loadingState: newState)
    }^
}

func onError(
    query: String
) -> State<SearchState, Void> {
    .modify { state in
        state.copy(loadingState: .error(message: "An error happened while performing your query '\(query)'"))
    }^
}

func showDetails(
    _ repository: Repository
) -> State<SearchState, Void> {
    .modify { state in
        state.copy(modalState: .repositoryDetail(.loading(repository)))
    }^
}

func dismissDetails() -> State<SearchState, Void> {
    .modify { state in
        state.copy(modalState: .noModal)
    }^
}
