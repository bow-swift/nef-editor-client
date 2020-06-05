import UIKit
import SwiftUI
import GitHub

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // For some reason, I cannot set the background color of a SwiftUI List 🤷🏻‍♂️
        UITableView.appearance().backgroundColor = .clear
        
        // Remove any extra separator in the Lists
        UITableView.appearance().tableFooterView = UIView()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = appComponent()
        let recipe = schemeRecipe(urlContexts: connectionOptions.urlContexts)
        loadScene(scene, contentView: contentView)
    }
    
    func scene(_ scene: UIScene, openURLContexts urlContexts: Set<UIOpenURLContext>) {
        guard let windowScene = scene as? UIWindowScene,
              let window = windowScene.windows.first,
              let hostingController = window.rootViewController as? UIHostingController<AppComponentView> else { return }
        
        let recipe = schemeRecipe(urlContexts: urlContexts)
        let contentView = hostingController.rootView
        loadScene(scene, contentView: contentView)
    }
    
    func loadScene<V: View>(_ scene: UIScene, contentView: V) {
        guard let windowScene = scene as? UIWindowScene else { return }
            
        let window = self.window ?? windowScene.windows.first ?? UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
    }
    
    // MARK: - read recipe from URL scheme
    
    func schemeRecipe(urlContexts: Set<UIOpenURLContext>) -> Recipe? {
        guard let url = urlContexts.first?.url,
              let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let action = components.host,
              let params = components.queryItems else { return nil }
        
        switch action {
        case "recipe":
            return buildRecipe(params: params)
        default:
            return nil
        }
    }
    
    func buildRecipe(params: [URLQueryItem]) -> Recipe? {
        guard let title = params.first(where: { $0.name == "name" })?.value,
              let url = params.first(where: { $0.name == "url" })?.value,
              let requirement = buildRequirement(params: params) else { return nil }
        
        let description = params.first { $0.name == "description" }?.value
        let dependency = Dependency(repository: title,
                                    owner: "",
                                    url: url,
                                    avatar: "",
                                    requirement: requirement)
        
        return Recipe(title: title,
                      description: description ?? "",
                      dependencies: [dependency])
    }
    
    func buildRequirement(params: [URLQueryItem]) -> Requirement? {
        let branch = params.first { $0.name == "branch" }?.value
        let tag = params.first { $0.name == "tag" }?.value
        
        if let branch = branch {
            return .branch(.init(name: branch))
        } else if let tag = tag {
            return .version(.init(name: tag))
        } else {
            return nil
        }
    }
}
