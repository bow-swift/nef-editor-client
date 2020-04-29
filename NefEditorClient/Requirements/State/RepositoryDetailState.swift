import GitHub

enum RepositoryDetailState: Equatable {
    case loading(Repository)
    case empty(Repository)
    case loaded(Repository, requirements: [Requirement])
    case error(Repository, message: String)
    
    var repository: Repository {
        switch self {
        case .loading(let repo),
             .empty(let repo),
             .loaded(let repo, requirements: _),
             .error(let repo, message: _): return repo
        }
    }
}
