import SwiftUI

// MARK: - ViewModifier
struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var font: ScaledFontType

    func body(content: Content) -> some View {
        content.font(font.dynamic)
    }
}

// MARK: - Models
enum ScaledFontType {
    case system(desiredSize: CGFloat, weight: Font.Weight)
    case custom(desiredSize: CGFloat, name: String)
    
    var dynamic: Font {
        let scaledSize = UIFontMetrics.default.scaledValue(for: desiredSize)
        
        switch self {
        case let .custom(_, name):
            return .custom(name, size: scaledSize)
        case let .system(_, weight):
            return .system(size: scaledSize, weight: weight)
        }
    }
    
    var desiredSize: CGFloat {
        switch self {
        case let .system(desiredSize, _):
            return desiredSize
        case let .custom(desiredSize, _):
            return desiredSize
        }
    }
}

// MARK: - Helpers
extension View {
    func scaledFont(_ font: ScaledFontType) -> some View {
        modifier(ScaledFont(font: font))
    }
}
