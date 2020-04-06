import SwiftUI

struct EmptySearchView: View {
    let query: String
    
    var body: some View {
        Text("Your query '\(query)' did not produce any results.")
            .activityStyle()
    }
}

struct EmptySearchView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySearchView(query: "Bow")
            .previewLayout(.sizeThatFits)
    }
}
