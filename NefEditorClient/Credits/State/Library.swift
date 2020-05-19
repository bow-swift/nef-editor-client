import Foundation

enum Library {
    case bow
    case bowArch
    case bowOpenAPI
    
    var url: URL? {
        switch self {
        case .bow:
            return URL(string: "https://bow-swift.io")
        case .bowArch:
            return URL(string: "https://arch.bow-swift.io")
        case .bowOpenAPI:
            return URL(string: "https://openapi.bow-swift.io")
        }
    }
}
