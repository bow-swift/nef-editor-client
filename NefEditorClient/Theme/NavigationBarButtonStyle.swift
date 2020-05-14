import SwiftUI

extension Button {
    func navigationBarButtonStyle() -> some View {
        self.buttonStyle(NavigationBarButtonStyle())
    }
}

struct NavigationBarButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.nef)
            .padding(8)
            .contentShape(RoundedRectangle(cornerRadius: 4))
            .safeHoverEffect()
        
    }
}
