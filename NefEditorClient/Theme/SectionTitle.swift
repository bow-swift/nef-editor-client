import SwiftUI

struct SectionTitle: View {
    struct Action {
        let icon: Image
        let handle: () -> Void
        
        init(icon: Image, handle: @autoclosure @escaping () -> Void) {
            self.icon = icon
            self.handle = handle
        }
    }
    
    let title: String
    let action: Action?
    
    init(title: String, action: Action? = nil) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .largeTitleStyle()
            self.actionView()
            Spacer()
        }
    }
    
    private func actionView() -> some View {
        guard let action = action else {
            return AnyView(EmptyView())
        }
            
        return AnyView(
            Button(action: action.handle) { action.icon }
                .buttonStyle(ActionButtonStyle())
                .offset(x: 16, y: 4)
        )
    }
}
