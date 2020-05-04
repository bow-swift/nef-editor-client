import SwiftUI

struct EmptySearchView: View {
    let query: String
    
    var body: some View {
        ActivityTextView(message: "Your query '\(query)' did not produce any results.")
    }
}

#if DEBUG
struct EmptySearchView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySearchView(query: "Bow")
            .previewLayout(.sizeThatFits)
    }
}
#endif
