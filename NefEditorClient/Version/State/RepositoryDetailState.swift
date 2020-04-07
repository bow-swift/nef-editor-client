import GitHub

enum RepositoryDetailState {
    case loading(Repository)
    case empty(Repository)
    case loaded(Repository, requirements: [Requirement])
    case error(message: String)
}
