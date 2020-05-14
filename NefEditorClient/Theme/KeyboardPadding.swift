import SwiftUI
import Combine

struct KeyboardPadding: ViewModifier {
    @State var currentHeight: CGFloat = 0
    let maxPadding: CGFloat
    
    init(maxPadding: CGFloat = .infinity) {
        self.maxPadding = maxPadding
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, min(currentHeight, maxPadding))
            .edgesIgnoringSafeArea(currentHeight == 0 ? [] : .bottom)
            .onAppear(perform: subscribeToKeyboardEvents)
    }
    
    private func subscribeToKeyboardEvents() {
        NotificationCenter.Publisher(
            center: NotificationCenter.default,
            name: UIResponder.keyboardWillShowNotification
        ).compactMap { notification in
            notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
        }.map { rect in
            rect.height
        }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
        
        NotificationCenter.Publisher(
            center: NotificationCenter.default,
            name: UIResponder.keyboardWillHideNotification
        ).compactMap { _ in
            CGFloat.zero
        }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
    }
}
