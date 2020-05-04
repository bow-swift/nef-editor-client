import SwiftUI

struct TagView: View {
    let tag: TagViewModel

    var body: some View {
        Text(tag.text)
            .lineLimit(1)
            .font(.system(.callout, design: .monospaced))
            .foregroundColor(tag.foregroundColor)
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(tag.backgroundColor)
            )
    }
}

#if DEBUG
struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TagView(tag: sampleBowTag)
            TagView(tag: sampleNefTag)
        }
        .previewLayout(.sizeThatFits)
            .padding(16)
    }
}
#endif
