import SwiftUI

struct LoadingSearchView: View {
    let query: String
    
    var body: some View {
        VStack {
            ActivityIndicator(isAnimating: .constant(true), style: .large)
            
            Text("Searching Swift repositories with query '\(query)'...")
                .activityStyle()
        }
    }
}

struct LoadingSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSearchView(query: "Bow")
            .previewLayout(.sizeThatFits)
    }
}
