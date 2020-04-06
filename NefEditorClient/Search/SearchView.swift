import SwiftUI
import GitHub

struct SearchView: View {
    @EnvironmentObject var orientationInfo: OrientationInfo
    let repositories: Repositories
    @State var query: String = ""
    
    var body: some View {
        VStack {
            SearchBar(placeholder: "Search repositories...", query: $query)
            
            ScrollView {
                RepositoryGridView(repositories: repositories, columns: self.columns)
                .padding()
            }
        }
    }
    
    var columns: Int {
        switch orientationInfo.orientation {
        case .landscape: return 2
        case .portrait: return 1
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(repositories: sampleSearchResults)
        .environmentObject(OrientationInfo())
    }
}
