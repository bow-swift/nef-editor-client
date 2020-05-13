import SwiftUI

extension View {
    func modal<V: View>(
        isPresented: Binding<Bool>,
        withNavigation: Bool = true,
        @ViewBuilder content: @escaping () -> V
    ) -> some View {
        background(
            EmptyView().sheet(isPresented: isPresented) {
                Group {
                    if withNavigation {
                        NavigationView {
                            content()
                        }.navigationViewStyle(StackNavigationViewStyle())
                    } else {
                        content()
                    }
                }
            }
        )
    }
}
