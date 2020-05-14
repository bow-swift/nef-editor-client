import SwiftUI
import Lottie

enum LottieAnimation: String {
    case generalError = "general-error"
    case githubSearch = "github-search"
    case playgroundLoading = "playgroundbook-loading"
    case playgroundSuccess = "playgroundbook-success"
}

extension LottieAnimation {
    func view(isLoop: Bool) -> AnimationLottieView? {
        guard let animation = Lottie.Animation.named(rawValue, subdirectory: "Animations") else { return nil }
        return AnimationLottieView(animation: animation, isLoop: isLoop)
    }
}

struct AnimationLottieView: UIViewRepresentable {
    let animation: Lottie.Animation
    let isLoop: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<AnimationLottieView>) -> UIView {
        let view = UIView()
        let animationView = AnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    func updateUIView(_ view: UIView, context: UIViewRepresentableContext<AnimationLottieView>) {
        let environment = context.coordinator.parent
        guard let view = view.subviews.first,
              let animationView = view as? AnimationView else { return }
        
        animationView.animation = environment.animation
        animationView.loopMode = environment.isLoop ? .loop : .playOnce
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
