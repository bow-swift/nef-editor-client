import SwiftUI

struct LoadingSearchView: View {
    let query: String
    
    var body: some View {
        LoadingView(message: "Searching Swift repositories with query '\(query)'...")
    }
}

#if DEBUG
struct LoadingSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSearchView(query: "Bow")
            .previewLayout(.sizeThatFits)
    }
}
#endif
