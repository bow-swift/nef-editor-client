import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(8)
            .foregroundColor(.white)
            .contentShape(Circle())
            .background(
                Circle().fill(
                    configuration.isPressed
                        ? Color.nef.opacity(0.7)
                        : Color.nef))
            .safeHoverEffect()
    }
}
