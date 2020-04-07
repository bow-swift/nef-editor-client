import SwiftUI

struct ActivityTextView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .activityStyle()
            .multilineTextAlignment(.center)
    }
}

struct ActivityTextView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTextView(message: "This is a sample message.")
            .previewLayout(.sizeThatFits)
    }
}
