import SwiftUI

struct ErrorSearchView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .activityStyle()
            .multilineTextAlignment(.center)
    }
}

struct ErrorSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorSearchView(message: "An unexpected error happened while searching for 'Bow'.")
            .previewLayout(.sizeThatFits)
    }
}
