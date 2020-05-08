import Bow

enum GenerationAction {
    case authenticationResult(Either<Error, AuthenticationInfo>)
    case dismissGeneration
}
