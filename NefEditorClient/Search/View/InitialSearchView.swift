import SwiftUI

struct InitialSearchView: View {
    var body: some View {
        ActivityTextView(message: "Search GitHub for your favorite Swift repositories and add them to your nef recipe.")
    }
}

struct InitialSearchView_Previews: PreviewProvider {
    static var previews: some View {
        InitialSearchView()
            .previewLayout(.sizeThatFits)
    }
}
