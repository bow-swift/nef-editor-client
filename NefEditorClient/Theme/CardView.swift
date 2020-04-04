import SwiftUI

struct CardView<Content: View>: View {
    let content: () -> Content
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 1, y: 1)
            self.content()
        }
    }
}

struct CardView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            cardSized(width: 200, height: 200)
            cardSized(width: 400, height: 100)
            cardSized(width: 100, height: 400)
        }
    }
    
    static func cardSized(width: CGFloat, height: CGFloat) -> some View {
        CardView {
            EmptyView()
        }.frame(width: width, height: height)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
