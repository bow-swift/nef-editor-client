import UIKit
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
        
        // Create the SwiftUI view that provides the window contents.
        let componentView = appComponent()
        loadScene(scene, contentView: componentView)
        onAppear(componentView: componentView, urlContexts: connectionOptions.urlContexts)
    }
    
    func scene(_ scene: UIScene, openURLContexts urlContexts: Set<UIOpenURLContext>) {
        guard let windowScene = scene as? UIWindowScene,
              let window = windowScene.windows.first,
              let hostingController = window.rootViewController as? UIHostingController<AppComponentView> else { return }
        
        let componentView = hostingController.rootView
        loadScene(scene, contentView: componentView)
        onAppear(componentView: componentView, urlContexts: urlContexts)
    }
    
    private func loadScene<V: View>(_ scene: UIScene, contentView: V) {
        guard let windowScene = scene as? UIWindowScene else { return }
            
        let window = windowScene.windows.first ?? UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
    }
    
    private func onAppear(componentView: AppComponentView, urlContexts: Set<UIOpenURLContext>) {
        if let recipe = schemeRecipe(urlContexts: urlContexts) {
            componentView.handle(.schema(recipe))
        } else {
            componentView.handle(.initialLoad)
        }
    }
    
    private func schemeRecipe(urlContexts: Set<UIOpenURLContext>) -> Recipe? {
        guard let url = urlContexts.first?.url,
              let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let action = components.host,
              let params = components.queryItems else { return nil }
        
        switch action {
        case "recipe":
            return params.recipe
        default:
            return nil
        }
    }
}
