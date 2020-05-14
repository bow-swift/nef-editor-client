import SwiftUI

extension View {
    func safeHoverEffect() -> some View {
        if #available(iOS 13.4, *) {
            return AnyView(self.hoverEffect())
        } else {
            return AnyView(self)
        }
    }
}
