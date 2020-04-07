import SwiftUI

struct InitialSearchView: View {
    var body: some View {
        Text("Search GitHub for your favorite Swift repositories and add them to your nef recipe.")
            .activityStyle()
            .multilineTextAlignment(.center)
    }
}

struct InitialSearchView_Previews: PreviewProvider {
    static var previews: some View {
        InitialSearchView()
            .previewLayout(.sizeThatFits)
    }
}
