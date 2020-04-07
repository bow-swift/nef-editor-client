import SwiftUI
import GitHub

struct RepositoryDetailView: View {
    let state: RepositoryDetailState
    
    var body: some View {
        self.contentView
            .navigationBarTitle(state.repository.name)
    }
    
    var contentView: some View {
        switch state {
        case .empty(let repo):
            return AnyView(EmptyRequirementsView(repository: repo))
        case .loading(let repo):
            return AnyView(LoadingRequirementsView(repository: repo))
        case .loaded(_, requirements: let requirements):
            return AnyView(RequirementListView(requirements: requirements))
        case .error(_, message: let message):
            return AnyView(ErrorRequirementsView(message: message))
        }
    }
}

struct RepositoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                RepositoryDetailView(state: .empty(bow))
            }.navigationViewStyle(StackNavigationViewStyle())
            
            NavigationView {
                RepositoryDetailView(state: .loading(bow))
            }.navigationViewStyle(StackNavigationViewStyle())
            
            NavigationView {
                RepositoryDetailView(state: .loaded(bow, requirements: [version, branch]))
            }.navigationViewStyle(StackNavigationViewStyle())
            
            NavigationView {
                RepositoryDetailView(state: .error(bow, message: "Could not load tags or branches."))
            }.navigationViewStyle(StackNavigationViewStyle())
        }.previewLayout(.fixed(width: 500, height: 500))
    }
}
