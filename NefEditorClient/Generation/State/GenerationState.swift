import Foundation

enum GenerationState: Equatable {
    case notGenerating
    case authenticating
    case initial(AuthenticationState, CatalogItem)
    case generating(CatalogItem)
    case finished(CatalogItem, URL, SharingState)
    case error(GenerationError)
    
    var shouldShowShare: Bool {
        guard case let .finished(_, _, sharingState) = self else {
            return false
        }
        return sharingState == .sharing
    }
}

enum SharingState: Equatable {
    case notSharing
    case sharing
}

enum GenerationError: Error, Equatable, CustomStringConvertible {
    case invalidAuthentication
    case invalidBearer
    case networkFailure
    case dataCorrupted
    
    var description: String {
        switch self {
        case .invalidAuthentication:
            return "There was a problem with your authentication. Please, try again later."
        case .invalidBearer:
            return "Oops! Your session has expired, please login again."
        case .networkFailure:
            return "An error ocurred while obtaining your Swift Playground. Please, try again later."
        case .dataCorrupted:
            return "Data for this Playground is corrupted. Please, try to generate it again."
        }
    }
}
