import Foundation

enum FAQAction {
    case visitNef
    case visit47Degrees
    case visitBowSwift
    case followBowSwift
    case dismissFAQ
    
    var url: URL? {
        switch self {
        case .visitNef:
            return URL(string: "https://github.com/bow-swift/nef")
        case .visit47Degrees:
            return URL(string: "https://www.47deg.com")
        case .visitBowSwift:
            return URL(string: "https://www.bow-swift.io")
        case .followBowSwift:
            return URL(string: "https://www.twitter.com/bow-swift")
        default:
            return nil
        }
    }
}
