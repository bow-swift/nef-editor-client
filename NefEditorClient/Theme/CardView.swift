import SwiftUI

struct CardView<Content: View>: View {
    let isSelected: Bool
    let content: () -> Content
    
    init(isSelected: Bool = false,
         @ViewBuilder content: @escaping () -> Content) {
        self.isSelected = isSelected
        self.content = content
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(
                    color: isSelected ? Color.black.opacity(0.3) : Color.black.opacity(0.1),
                    radius: isSelected ? 6 : 2,
                    x: 1,
                    y: 1)
            self.content()
        }
    }
}

#if DEBUG
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
#endif
