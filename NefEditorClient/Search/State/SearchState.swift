import GitHub
import BowOptics

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
    
    static var modalStateLens: Lens<SearchState, SearchModalState> {
        Lens(
            get: { search in search.modalState },
            set: { search, modal in search.copy(modalState: modal) })
    }
}

enum SearchLoadingState {
    case initial
    case loading(query: String)
    case empty(query: String)
    case loaded(Repositories)
    case error(message: String)
}

enum SearchModalState: Equatable {
    case noModal
    case repositoryDetail(RepositoryDetailState)
}
