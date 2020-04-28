import SwiftUI
import GitHub

struct SearchView: View {
    let state: SearchState
    @State var query: String = ""
    let detail: (Repository) -> RepositoryDetailComponent
    let handle: (SearchAction) -> Void
    let isModalPresented: Binding<Bool>
    
    init(
        state: SearchState,
        detail: @escaping (Repository) -> RepositoryDetailComponent,
        handle: @escaping (SearchAction) -> Void) {
        self.state = state
        self.detail = detail
        self.handle = handle
        self.isModalPresented = Binding(
            get: { state.modalState != .noModal },
            set: { isPresented in handle(.dismissDetails) })
    }
    
    var body: some View {
        VStack {
            self.searchView
            self.contentView.fill.layoutPriority(1)
        }.sheet(isPresented: isModalPresented) {
            NavigationView {
                self.modalView(self.state.modalState)
            }.navigationViewStyle(StackNavigationViewStyle())
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
    
    private func modalView(_ state: SearchModalState) -> some View {
        if case let .repositoryDetail(repo) = state {
            return AnyView(self.detail(repo))
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static func state(_ loadingState: SearchLoadingState) -> SearchState {
        SearchState(loadingState: loadingState, modalState: .noModal)
    }
    
    static func detailPreview(_ repository: Repository) -> RepositoryDetailComponent {
        fatalError("RepositoryDetailComponent will not be rendered in a preview")
    }
    
    static var previews: some View {
        Group {
            SearchView(state: state(.initial), detail: detailPreview) { _ in }
            
            SearchView(state: state(.empty(query: "Bow")), detail: detailPreview) { _ in }
            
            SearchView(state: state(.loading(query: "Bow")), detail: detailPreview) { _ in }
            
            SearchView(state: state(.loaded(sampleSearchResults)), detail: detailPreview) { _ in }
            
            SearchView(state: state(.loaded(sampleRepos)), detail: detailPreview) { _ in }
            
            SearchView(state: state(.error(message: "Unexpected error happened.")), detail: detailPreview) { _ in }
        }
        .previewLayout(.fixed(width: 910, height: 1024))
    }
}
