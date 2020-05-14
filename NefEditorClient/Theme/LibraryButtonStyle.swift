import SwiftUI

struct LibraryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(4)
            .contentShape(RoundedRectangle(cornerRadius: 8))
            .background(RoundedRectangle(cornerRadius: 8)
                .fill(configuration.isPressed
                    ? Color.nef.opacity(0.1)
                    : Color.clear))
            .safeHoverEffect()
    }
}
