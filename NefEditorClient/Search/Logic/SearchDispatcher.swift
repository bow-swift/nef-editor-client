import GitHub
import Bow
import BowArch
import BowEffects

typealias SearchDispatcher = StateDispatcher<API.Config, SearchState, SearchAction>
typealias SearchHandler = StateHandler<API.Config, SearchState, SearchAction>

let searchDispatcher = SearchDispatcher { action, handler in
    switch action {
        
    case .search(query: let query):
        return search(query: query, handler: handler)
            .handleErrorWith { _ in onError(query: query, handler: handler) }^
        
    case .loadResults(let repositories, query: let query):
        let newLoadingState = loadResults(repositories, for: query)
        return handler.send(action:
            .modify { state in
                state.copy(loadingState: newLoadingState)
            })
        
    case .showDetails(let repository):
        return handler.send(action:
            .modify { state in
                state.copy(modalState: .repositoryDetail(repository))
            }
        )
        
    case .dismissDetails:
        return handler.send(action:
            .modify { state in
                state.copy(modalState: .noModal)
            }
        )
    }
}

func search(
    query: String,
    handler: SearchHandler
) -> EnvIO<API.Config, Error, [SearchAction]> {
    let repositories = EnvIO<API.Config, Error, Repositories>.var()
    
    return binding(
        |<-handler.send(action: .modify { state in
            state.copy(loadingState: .loading(query: query))
        }),
        continueOn(.global(qos: .background)),
        repositories <- gitHubSearch(query: query),
        yield: [.loadResults(repositories.get, query: query)])^
}

func gitHubSearch(
    query: String
) -> EnvIO<API.Config, Error, Repositories> {
    
    API.search.searchRepositories(q: "\(query)+language:Swift" )
        .bimap(id, { result in result.items })
}

func onError(
    query: String,
    handler: SearchHandler
) -> EnvIO<API.Config, Error, [SearchAction]> {
    handler.send(action:
        .modify { state in
            state.copy(loadingState: .error(message: "An error happened while performing your query '\(query)'"))
        })
}

func loadResults(
    _ repositories: Repositories,
    for query: String
) -> SearchLoadingState {
    
    if repositories.isEmpty {
        return .empty(query: query)
    } else {
        return .loaded(repositories)
    }
}
