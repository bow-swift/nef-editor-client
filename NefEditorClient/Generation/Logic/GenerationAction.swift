import Bow
import Foundation

enum GenerationAction {
    case authenticationResult(Either<Error, AuthenticationInfo>, item: CatalogItem)
    case dismissGeneration
    case generate(item: CatalogItem, token: String)
    case sharePlayground
    case dismissShare
}
