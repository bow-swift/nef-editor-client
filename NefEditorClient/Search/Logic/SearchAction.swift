import GitHub

enum SearchAction {
    case search(query: String)
    case loadResults(Repositories, query: String)
}
