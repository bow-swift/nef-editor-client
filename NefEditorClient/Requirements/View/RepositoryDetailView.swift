import SwiftUI
import GitHub

struct RepositoryDetailView: View {
    let state: SearchModalState
    let handle: (RepositoryDetailAction) -> Void
    
    var body: some View {
        self.contentView
            .navigationBarTitle(self.title)
            .onAppear {
                self.loadRequirements()
            }
    }
    
    private var title: String {
        switch state {
        case .noModal: return ""
        case .repositoryDetail(let detail): return detail.repository.name
        }
    }
    
    private var contentView: some View {
        switch state {
        case .noModal: return AnyView(EmptyView())
        case .repositoryDetail(let detail):
            switch detail {
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
    
    private func loadRequirements() {
        switch state {
        case .repositoryDetail(let detail):
            self.handle(.loadRequirements(detail.repository))
        case .noModal: return
        }
    }
}

struct RepositoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                RepositoryDetailView(state: .repositoryDetail(.empty(bow))) { _ in }
            }.navigationViewStyle(StackNavigationViewStyle())
            
            NavigationView {
                RepositoryDetailView(state: .repositoryDetail(.loading(bow))) { _ in }
            }.navigationViewStyle(StackNavigationViewStyle())
            
            NavigationView {
                RepositoryDetailView(state: .repositoryDetail(.loaded(bow, requirements: [version, branch]))) { _ in }
            }.navigationViewStyle(StackNavigationViewStyle())
            
            NavigationView {
                RepositoryDetailView(state: .repositoryDetail(.error(bow, message: "Could not load tags or branches."))) { _ in }
            }.navigationViewStyle(StackNavigationViewStyle())
        }.previewLayout(.fixed(width: 500, height: 500))
    }
}
