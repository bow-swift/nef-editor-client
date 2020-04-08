import SwiftUI

struct TagView: View {
    let text: String
    let foregroundColor: Color
    let backgroundColor: Color
    
    init(
        text: String,
        foregroundColor: Color = .gray,
        backgroundColor: Color = Color.gray.opacity(0.2)) {
        self.text = text
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        Text(text)
            .lineLimit(1)
            .font(.callout)
            .foregroundColor(self.foregroundColor)
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(self.backgroundColor)
            )
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TagView(text: "bow-swift/bow")
            TagView(text: "nef",
                    foregroundColor: .yellow,
                    backgroundColor: .purple)
        }
        .previewLayout(.sizeThatFits)
            .padding(16)
    }
}
