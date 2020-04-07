import SwiftUI
import GitHub

struct EmptyRequirementsView: View {
    let repository: Repository
    
    var body: some View {
        ActivityTextView(message: "'\(repository.fullName)' does not contain any tag or branch.")
    }
}

struct EmptyRequirementsView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyRequirementsView(repository: sampleRepo)
            .previewLayout(.sizeThatFits)
    }
}
