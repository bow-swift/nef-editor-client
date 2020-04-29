import SwiftUI
import GitHub

struct SearchView: View {
    let state: SearchState
    @State var query: String = ""
    let handle: (SearchAction) -> Void
    
    init(
        state: SearchState,
        handle: @escaping (SearchAction) -> Void) {
        self.state = state
        self.handle = handle
    }
    
    var body: some View {
        VStack {
            self.searchView
            self.contentView.fill.layoutPriority(1)
        }
    }
    
    private var searchView: some View {
        CardView {
            HStack {
                SearchBar(placeholder: "Search repositories...", query: self.$query) { query in
                    self.handle(.search(query: query))
                }
                
                Button(action: { self.handle(.cancelSearch) }) {
                    Text("Cancel").foregroundColor(.nef)
                }.padding(.trailing)
            }
        }.padding(.top).padding(.horizontal)
    }
    
    private var contentView: some View {
        switch state.loadingState {
        case .initial:
            return AnyView(InitialSearchView())
        case .loading(let query):
            return AnyView(LoadingSearchView(query: query))
        case .empty(let query):
            return AnyView(EmptySearchView(query: query))
        case .loaded(let repositories):
            return AnyView(loadedView(repositories: repositories))
        case .error(let message):
            return AnyView(ErrorSearchView(message: message))
        }
    }
    
    private func loadedView(repositories: Repositories) -> some View {
        GeometryReader { geometry in
            ScrollView {
                RepositoryGridView(
                    repositories: repositories,
                    columns: self.columns(for: geometry.size.width)) { repository in
                        self.handle(.showDetails(repository))
                }
                .padding()
                .fill
            }
        }
    }
    
    private func columns(for width: CGFloat) -> Int {
        let minimumCardWidth: CGFloat = 350
        return Int(floor(width / minimumCardWidth))
    }
}

struct SearchView_Previews: PreviewProvider {
    static func state(_ loadingState: SearchLoadingState) -> SearchState {
        SearchState(loadingState: loadingState, modalState: .noModal)
    }
    
    static var previews: some View {
        Group {
            SearchView(state: state(.initial)) { _ in }
            
            SearchView(state: state(.empty(query: "Bow"))) { _ in }
            
            SearchView(state: state(.loading(query: "Bow"))) { _ in }
            
            SearchView(state: state(.loaded(sampleSearchResults))) { _ in }
            
            SearchView(state: state(.loaded(sampleRepos))) { _ in }
            
            SearchView(state: state(.error(message: "Unexpected error happened."))) { _ in }
        }
        .previewLayout(.fixed(width: 910, height: 1024))
    }
}
