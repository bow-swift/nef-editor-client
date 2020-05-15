import SwiftUI

struct AnimationView: View {
    struct Animation: Identifiable {
        var id: LottieAnimation { lottie }
        
        let lottie: LottieAnimation
        let isLoop: Bool
        
        init(lottie: LottieAnimation, isLoop: Bool = false) {
            self.lottie = lottie
            self.isLoop = isLoop
        }
    }
    
    let animation: Animation?
    
    init(animation: Animation? = nil) {
        self.animation = animation
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.animationView(size: geometry.size)
        }
    }
    
    private func animationView(size: CGSize) -> some View {
        guard let animation = animation,
              let lottieView = animation.lottie.view(isLoop: animation.isLoop) else {
            return AnyView(ActivityIndicator(isAnimating: .constant(true), style: .large))
        }
        
        return AnyView(
            lottieView
                .offset(animation.lottie.fixOffset)
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
        )
    }
}
