import SwiftUI
import GitHub
import BowArch

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // For some reason, I cannot set the background color of a SwiftUI List 🤷🏻‍♂️
        UITableView.appearance().backgroundColor = .clear
        
        // Remove any extra separator in the Lists
        UITableView.appearance().tableFooterView = UIView()
        
        loadScene(scene, contentView: appComponent(deepLink: connectionOptions.urlContexts))
    }
    
    func scene(_ scene: UIScene, openURLContexts urlContexts: Set<UIOpenURLContext>) {
        loadScene(scene, contentView: appComponent(deepLink: urlContexts))
    }
    
    private func loadScene<V: View>(_ scene: UIScene, contentView: V) {
        guard let windowScene = scene as? UIWindowScene else { return }
            
        let window = windowScene.windows.first ?? UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
    }
}
