import Foundation

enum GenerationState: Equatable {
    case notGenerating
    case authenticating
    case initial(AuthenticationState, CatalogItem)
    case generating(CatalogItem)
    case finished(CatalogItem, URL)
    case error(GenerationError)
}

enum GenerationError: Error, Equatable, CustomStringConvertible {
    case invalidAuthentication
    case networkFailure
    case dataCorrupted
    
    var description: String {
        switch self {
        case .invalidAuthentication:
            return "There was a problem with your authentication. Please, try again later."
        case .networkFailure:
            return "An error ocurred while obtaining your Swift Playground. Please, try again later."
        case .dataCorrupted:
            return "Data for this Playground is corrupted. Please, try to generate it again."
        }
    }
}
