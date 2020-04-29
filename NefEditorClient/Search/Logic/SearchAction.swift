import GitHub

enum SearchAction {
    case search(query: String)
    case showDetails(Repository)
    case dismissDetails
    case cancelSearch
}
