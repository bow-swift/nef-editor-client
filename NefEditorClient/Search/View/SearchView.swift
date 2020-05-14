import SwiftUI
import GitHub

struct SearchView<Detail: View>: View {
    let state: SearchState
    let detail: Detail
    @State var query: String = ""
    let handle: (SearchAction) -> Void
    
    let isDetailPresented: Binding<Bool>
    
    init(
        state: SearchState,
        detail: Detail,
        handle: @escaping (SearchAction) -> Void) {
        self.state = state
        self.detail = detail
        self.handle = handle
        self.isDetailPresented = Binding(
            get: { state.modalState != .noModal },
            set: { newState in
                if !newState {
                    handle(.dismissDetails)
                }
            })
    }
    
    var body: some View {
        VStack {
            self.searchView
            self.contentView.fill.layoutPriority(1)
        }.modal(isPresented: isDetailPresented) {
            self.detail
        }.modifier(KeyboardPadding())
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
        }.padding(.top).padding(.trailing)
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
                .padding(.trailing)
                .fill
            }
        }
    }
    
    private func columns(for width: CGFloat) -> Int {
        let minimumCardWidth: CGFloat = Card.minimumWidth
        return max(Int(floor(width / minimumCardWidth)), 1)
    }
}

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static func state(_ loadingState: SearchLoadingState) -> SearchState {
        SearchState(loadingState: loadingState, modalState: .noModal)
    }
    
    static var previews: some View {
        Group {
            SearchView(state: state(.initial), detail: EmptyView()) { _ in }
            
            SearchView(state: state(.empty(query: "Bow")), detail: EmptyView()) { _ in }
            
            SearchView(state: state(.loading(query: "Bow")), detail: EmptyView()) { _ in }
            
            SearchView(state: state(.loaded(sampleSearchResults)), detail: EmptyView()) { _ in }
            
            SearchView(state: state(.loaded(sampleRepos)), detail: EmptyView()) { _ in }
            
            SearchView(state: state(.error(message: "Unexpected error happened.")), detail: EmptyView()) { _ in }
        }
        .previewLayout(.fixed(width: 910, height: 1024))
    }
}
#endif
