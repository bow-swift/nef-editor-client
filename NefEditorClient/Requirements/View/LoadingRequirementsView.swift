import SwiftUI
import GitHub

struct LoadingRequirementsView: View {
    let repository: Repository
    
    var body: some View {
        LoadingView(message: "Loading tags and branches for repository '\(repository.fullName)'...")
    }
}

struct LoadingRequirementsView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingRequirementsView(repository: sampleRepo)
            .previewLayout(.sizeThatFits)
    }
}
