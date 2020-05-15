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
    
    let animation: Animation
    
    init(animation: Animation) {
        self.animation = animation
    }
    
    var body: some View {
        self.animationView()
    }
    
    private func animationView() -> some View {
        guard let lottieView = animation.lottie.view(isLoop: animation.isLoop) else {
            return AnyView(ActivityIndicator(isAnimating: .constant(true), style: .large))
        }
        
        return AnyView(
            GeometryReader { geometry in
                lottieView
                    .offset(self.animation.lottie.fixOffset(size: geometry.size))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        )
    }
}
