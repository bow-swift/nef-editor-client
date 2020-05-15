import SwiftUI

struct LoadingView: View, Identifiable {
    struct Animation: Identifiable {
        var id: LottieAnimation { lottie }
        
        let lottie: LottieAnimation
        let isLoop: Bool
        
        init(lottie: LottieAnimation, isLoop: Bool = false) {
            self.lottie = lottie
            self.isLoop = isLoop
        }
    }
    
    let message: String
    let animation: Animation?
    var id: String { message }
    
    init(message: String, animation: Animation? = nil) {
        self.message = message
        self.animation = animation
    }
    
    var body: some View {
        VStack {
            self.animationView()
            
            Text(self.message)
                .activityStyle()
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func animationView() -> some View {
        guard let animation = animation,
              let lottieView = animation.lottie.view(isLoop: animation.isLoop) else {
            return AnyView(ActivityIndicator(isAnimating: .constant(true), style: .large))
        }
        
        return AnyView(
            lottieView
            .offset(animation.lottie.fixOffset)
            .frame(width: 600, height: 300)
        )
    }
}
