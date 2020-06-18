import SwiftUI

func schemeRecipe(incomingURL: URL) -> Recipe? {
    guard let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
          let action = incomingURL.lastPathComponent.isEmpty ? components.host : incomingURL.lastPathComponent,
          let params = components.queryItems else { return nil }
    
    switch action {
    case "recipe":
        return params.recipe
    default:
        return nil
    }
}
