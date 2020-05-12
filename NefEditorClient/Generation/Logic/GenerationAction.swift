import Bow

enum GenerationAction {
    case authenticationResult(Either<Error, AuthenticationInfo>, item: CatalogItem)
    case dismissGeneration
    case generate(item: CatalogItem, info: AuthenticationInfo)
}
