import SwiftUI
import Lottie

enum LottieAnimation: String {
    case signinLoading = "signin-loading"
    case signinSuccess = "signin-done"
    case playgroundLoading = "playgroundbook-loading"
    case playgroundSuccess = "playgroundbook-success"
    case generalError = "error-deadpool"
}

extension LottieAnimation {
    func view(isLoop: Bool) -> AnimationLottieView? {
        guard let animation = Lottie.Animation.named(rawValue) else { return nil }
        return AnimationLottieView(animation: animation, isLoop: isLoop)
    }
}

struct AnimationLottieView: UIViewRepresentable {
    let animation: Lottie.Animation
    let isLoop: Bool
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let animationView = AnimationView()
        view.addSubview(animationView)
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        guard let view = view.subviews.first,
              let animationView = view as? AnimationView else { return }
        
        animationView.loopMode = isLoop ? .loop : .playOnce
        animationView.play()
    }
}
