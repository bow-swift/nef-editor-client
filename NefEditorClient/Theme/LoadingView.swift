import SwiftUI

struct LoadingView: View {
    let message: String
    
    var body: some View {
        VStack {
            ActivityIndicator(isAnimating: .constant(true), style: .large)
            Text(message).activityStyle()
        }
    }
}
