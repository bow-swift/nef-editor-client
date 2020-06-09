import SwiftUI

func schemeRecipe(urlContexts: Set<UIOpenURLContext>) -> Recipe? {
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
