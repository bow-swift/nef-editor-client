import SwiftUI

struct GenerationSuccessView: View {
    let animation: LottieAnimation
    
    var body: some View {
        LoadingView(message: "", animation: .init(lottie: animation))
    }
}
