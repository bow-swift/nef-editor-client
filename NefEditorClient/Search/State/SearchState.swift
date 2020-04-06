import GitHub

enum SearchState {
    case initial
    case loading(query: String)
    case empty(query: String)
    case loaded(Repositories)
    case error(message: String)
}
