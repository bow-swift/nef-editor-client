import SwiftUI

struct TextButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .font(Font.system(.body).bold())
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .contentShape(RoundedRectangle(cornerRadius: 8))
            .background(RoundedRectangle(cornerRadius: 8)
                .fill(configuration.isPressed
                    ? Color.nef.opacity(0.7)
                    : Color.nef))
            .safeHoverEffect()
    }
}
