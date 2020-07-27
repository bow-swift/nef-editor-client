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
        
        if let userActivity = connectionOptions.userActivities.first {
            loadScene(scene, contentView: appComponent(userActivity: userActivity))
        } else {
            loadScene(scene, contentView: appComponent(urlContexts: connectionOptions.urlContexts))
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts urlContexts: Set<UIOpenURLContext>) {
        loadScene(scene, contentView: appComponent(urlContexts: urlContexts))
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        loadScene(scene, contentView: appComponent(userActivity: userActivity))
    }
    
    private func loadScene<V: View>(_ scene: UIScene, contentView: V) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: contentView)
        window?.makeKeyAndVisible()
    }
}
