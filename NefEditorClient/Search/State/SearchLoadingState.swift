import GitHub

struct SearchState {
    let loadingState: SearchLoadingState
    let modalState: SearchModalState
    
    func copy(
        loadingState: SearchLoadingState? = nil,
        modalState: SearchModalState? = nil
    ) -> SearchState {
        SearchState(
            loadingState: loadingState ?? self.loadingState,
            modalState: modalState ?? self.modalState)
    }
}

enum SearchLoadingState {
    case initial
    case loading(query: String)
    case empty(query: String)
    case loaded(Repositories)
    case error(message: String)
}

enum SearchModalState {
    case noModal
    case repositoryDetails(Repository)
}
