enum FAQAction {
    case visitNef
    case visit47Degrees
    case visitBowSwift
    case followBowSwift
    
    var url: String {
        switch self {
        case .visitNef:
            return "https://github.com/bow-swift/nef"
        case .visit47Degrees:
            return "https://www.47deg.com"
        case .visitBowSwift:
            return "https://www.bow-swift.io"
        case .followBowSwift:
            return "https://www.twitter.com/bow-swift"
        }
    }
}
