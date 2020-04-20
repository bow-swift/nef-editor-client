import GitHub

enum SearchAction {
    case search(query: String)
    case loadResults(Repositories, query: String)
    case showDetails(Repository)
    case dismissDetails
}
