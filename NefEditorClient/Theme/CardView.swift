import SwiftUI

enum Card {
    static var minimumWidth: CGFloat {
        let screen = UIScreen.main.bounds
        let width = max(screen.size.width, screen.size.height)
        if width > 1100 {
            return 420
        } else {
            return 340
        }
    }
}

struct CardView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    
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
                .fill(Color.card)
                .if(colorScheme == .light,
                    then: {
                    $0.shadow(
                        color: self.isSelected ?
                            Color.shadow.opacity(0.3) :
                            Color.shadow.opacity(0.1),
                        radius: self.isSelected ? 6 : 2,
                        x: 1,
                        y: 1)
                })
                .if(isSelected && colorScheme == .dark,
                    then: {
                        $0.overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.shadow, lineWidth: 2)
                        )
                })
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
