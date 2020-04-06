import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    init(isAnimating: Binding<Bool>, style: UIActivityIndicatorView.Style = .medium) {
        self._isAnimating = isAnimating
        self.style = style
    }

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActivityIndicator(isAnimating: .constant(true))
                .previewLayout(.sizeThatFits)
            
            ActivityIndicator(isAnimating: .constant(true), style: .large)
                .previewLayout(.sizeThatFits)
            
            ActivityIndicator(isAnimating: .constant(false), style: .large)
            .previewLayout(.sizeThatFits)
        }
    }
}
