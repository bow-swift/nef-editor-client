import SwiftUI

struct GenerationSuccessView: View {
    let animation: LottieAnimation
    
    var body: some View {
        AnimationView(animation: .init(lottie: animation))
            .aspectRatio(contentMode: .fit)
            .frame(width: 256, height: 256)
    }
}
