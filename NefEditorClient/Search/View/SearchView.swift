import SwiftUI
import GitHub

struct SearchView: View {
    @EnvironmentObject var orientationInfo: OrientationInfo
    let state: SearchState
    @State var query: String = ""
    
    var body: some View {
        VStack {
            SearchBar(placeholder: "Search repositories...", query: $query)
            
            self.contentView.fill
        }
    }
    
    private var contentView: some View {
        switch state {
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
        ScrollView {
            RepositoryGridView(
                repositories: repositories,
                columns: self.columns)
            .padding()
        }
    }
    
    private var columns: Int {
        switch orientationInfo.orientation {
        case .landscape: return 2
        case .portrait: return 1
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchView(state: .initial)
            
            SearchView(state: .empty(query: "Bow"))
            
            SearchView(state: .loading(query: "Bow"))
            
            SearchView(state: .loaded(sampleSearchResults))
            
            SearchView(state: .loaded(sampleRepos))
            
            SearchView(state: .error(message: "Unexpected error happened."))
        }
        .previewLayout(.fixed(width: 910, height: 1024))
        .environmentObject(OrientationInfo(orientation: .landscape))
    }
}
