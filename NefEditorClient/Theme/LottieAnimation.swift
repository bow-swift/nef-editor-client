import SwiftUI
import Lottie

enum LottieAnimation: String {
    case generalError = "general-error"
    case generalLoading = "general-loading"
    case githubSearch = "github-search"
    case playgroundLoading = "playgroundbook-loading"
    case playgroundSuccess = "playgroundbook-success"
}

extension LottieAnimation {
    func view(isLoop: Bool) -> AnimationLottieView? {
        guard let animation = Lottie.Animation.named(rawValue, subdirectory: "Animations") else { return nil }
        return AnimationLottieView(id: rawValue, animation: animation, isLoop: isLoop)
    }
}

struct AnimationLottieView: UIViewRepresentable, Identifiable {
    let id: String
    let animation: Lottie.Animation
    let isLoop: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<AnimationLottieView>) -> UIView {
        UIView()
    }

    func updateUIView(_ view: UIView, context: UIViewRepresentableContext<AnimationLottieView>) {
        let animationView = AnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.subviews.first?.removeFromSuperview()
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        animationView.animation = animation
        animationView.loopMode = isLoop ? .loop : .playOnce
        animationView.play()
    }
    
    class Coordinator: NSObject {
        let parent: AnimationLottieView
    
        init(_ animationView: AnimationLottieView) {
            self.parent = animationView
            super.init()
        }
    }
}
