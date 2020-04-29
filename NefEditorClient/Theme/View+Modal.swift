import SwiftUI

extension View {
    func modal<V: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> V
    ) -> some View {
        background(
            EmptyView().sheet(isPresented: isPresented) {
                NavigationView {
                    content()
                }.navigationViewStyle(StackNavigationViewStyle())
            }
        )
    }
}
