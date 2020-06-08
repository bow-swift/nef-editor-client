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
    
    func loadScene<V: View>(_ scene: UIScene, contentView: V) {
        guard let windowScene = scene as? UIWindowScene else { return }
            
        let window = self.window ?? windowScene.windows.first ?? UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func onAppear(componentView: AppComponentView, urlContexts: Set<UIOpenURLContext>) {
        if let recipe = schemeRecipe(urlContexts: urlContexts) {
            componentView.handle(.schema(recipe))
        } else {
            componentView.handle(.initialLoad)
        }
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
