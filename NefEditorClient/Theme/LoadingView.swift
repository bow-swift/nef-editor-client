import SwiftUI

struct LoadingView: View, Identifiable {
    struct Animation: Identifiable {
        var id: LottieAnimation { lottie }
        
        let lottie: LottieAnimation
        let offset: CGPoint
        let isLoop: Bool
        
        init(lottie: LottieAnimation, isLoop: Bool = false, offset: CGPoint = .zero) {
            self.lottie = lottie
            self.offset = offset
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
                .padding()
            
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
                .offset(x: animation.offset.x, y: animation.offset.y)
                .frame(width: 600, height: 300)
        )
    }
}
