enum AuthenticationState: Equatable {
    case authenticated(token: String)
    case unauthenticated
}
