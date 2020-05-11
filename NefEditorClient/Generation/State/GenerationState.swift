enum GenerationState: Equatable {
    case notGenerating
    case initial(AuthenticationState, CatalogItem)
    case generating(CatalogItem)
    case error(GenerationError)
}

enum GenerationError: Equatable, CustomStringConvertible {
    case invalidAuthentication
    case networkFailure
    
    var description: String {
        switch self {
        case .invalidAuthentication:
            return "There was a problem with your authentication. Please try again later."
        case .networkFailure:
            return "An error ocurred while obtaining your Swift Playground. Please try again later."
        }
    }
}
