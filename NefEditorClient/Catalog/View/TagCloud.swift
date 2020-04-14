import SwiftUI

struct TagCloud: View {
    enum Layouts {
        static func multiline(spacing: CGFloat = 4, lines: UInt = .max) -> TagCloudLayout {
            MultilineLayout(spacing: spacing, lines: lines)
        }
    }
    
    let tags: [TagViewModel]
    let layout: TagCloudLayout
    @State var sizes: [CGSize] = []
    
    init(tags: [TagViewModel], spacing: CGFloat = 4, lines: UInt = .max) {
        self.init(tags: tags, layout: Layouts.multiline(spacing: spacing, lines: lines))
    }
    
    init(tags: [TagViewModel], layout: TagCloudLayout = Layouts.multiline()) {
        self.tags = tags
        self.layout = layout
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.sizeView(containerSize: geometry.size)
        }
    }
    
    private func sizeView(containerSize: CGSize) -> some View {
        let offsets = self.layout.offsets(elements: self.tags, containerSize: containerSize, elementSize: self.sizes)
        let size = wrappingSize(sizes: self.sizes, offsets: offsets)
        return self.contentView(size: CGSize(width: containerSize.width, height: size.height), offsets: offsets)
    }
    
    private func contentView(size: CGSize, offsets: [Offset]) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(Array(tags.enumerated()), id: \.element.text) { tag in
                SizedView(content: TagView(tag: tag.element))
                    .offset(offsets[tag.offset])
            }

            Color.clear
                .frame(width: size.width, height: size.height)
                .fixedSize()
        }.onPreferenceChange(TagCloudItemsSizePreferenceKey.self) { sizes in
            self.sizes = sizes
        }
        .frame(width: size.width, height: size.height)
        .fixedSize()
    }
    
    private func wrappingSize(sizes: [CGSize], offsets: [Offset]) -> CGSize {
        zip(sizes, offsets).reduce(CGSize.zero) { wrappingSize, element in
            let (size, offset) = element
            guard case let .visible(translation) = offset else {
                return wrappingSize
            }
            let width = max(wrappingSize.width, translation.x + size.width)
            let height = max(wrappingSize.height, translation.x + size.height)
            return CGSize(width: width, height: height)
        }
    }
}

protocol TagCloudLayout {
    func offsets<Element>(
        elements: [Element],
        containerSize: CGSize,
        elementSize: [CGSize]
    ) -> [Offset]
}

enum Offset {
    case visible(CGPoint)
    case hidden
}

private struct MultilineLayout: TagCloudLayout {
    let spacing: CGFloat
    let lines: UInt
    
    private struct OngoingLayout {
        let offsets: [Offset]
        let cursor: CGPoint
        let line: UInt
        
        static var empty: OngoingLayout {
            OngoingLayout(offsets: [], cursor: .zero, line: 0)
        }
        
        func appending(offset: Offset, nextCursor: CGPoint, line: UInt? = nil) -> OngoingLayout {
            OngoingLayout(
                offsets: self.offsets + [offset],
                cursor: nextCursor,
                line: line ?? self.line)
        }
    }
    
    func offsets<Element>(
        elements: [Element],
        containerSize: CGSize,
        elementSize: [CGSize]
    ) -> [Offset] {
        guard !elementSize.isEmpty else {
            return Array(repeating: .hidden, count: elements.count)
        }
        
        return elementSize.reduce(OngoingLayout.empty) { ongoing, element in
            // Maximum number of lines reached
            if ongoing.line > lines {
                
                return ongoing.appending(offset: .hidden, nextCursor: ongoing.cursor)
                
            // Element does not fit in the available height
            } else if ongoing.cursor.y + element.height > containerSize.height {
                
                return ongoing.appending(offset: .hidden, nextCursor: ongoing.cursor)
            
            // Element fits in the available width
            } else if ongoing.cursor.x + element.width < containerSize.width {
                
                let nextCursor = CGPoint(x: ongoing.cursor.x + element.width + spacing,
                                         y: ongoing.cursor.y)
                return ongoing.appending(offset: .visible(ongoing.cursor), nextCursor: nextCursor)
            
            // Element needs to go to the next line
            } else {
                let offset = CGPoint(x: 0, y: ongoing.cursor.y + spacing + element.height)
                
                if ongoing.line + 1 < lines && offset.y + element.height < containerSize.height {
                    let nextCursor = CGPoint(x: element.width + spacing, y: offset.y)
                    return ongoing.appending(offset: .visible(offset), nextCursor: nextCursor, line: ongoing.line + 1)
                } else {
                    return ongoing.appending(offset: .hidden, nextCursor: ongoing.cursor, line: ongoing.line + 1)
                }
            }
        }.offsets
    }
}

private struct TagCloudItemsSizePreferenceKey: PreferenceKey {
    typealias Value = [CGSize]
    
    static var defaultValue: [CGSize] { [] }
    
    static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue())
    }
}

private struct SizedView<Content: View>: View {
    let content: Content
    
    var body: some View {
        content.background(
            GeometryReader { geometry in
                Color.clear.preference(key: TagCloudItemsSizePreferenceKey.self, value: [geometry.size])
            }
        )
    }
    
    func offset(_ offset: Offset) -> some View {
        switch offset {
        case .visible(let point):
            return AnyView(self.offset(x: point.x, y: point.y))
        default:
            return AnyView(self.hidden())
        }
    }
}

struct TagCloud_Previews: PreviewProvider {
    static var tags = ["bow", "bow-openapi", "nef", "bow-arch", "nef-plugin"].map { tag in
        TagViewModel(text: tag, foregroundColor: .gray, backgroundColor: Color.gray.opacity(0.2))
    }
    
    static var previews: some View {
        Group {
            TagCloud(tags: tags)
            
            TagCloud(tags: tags, spacing: 16)
            
            TagCloud(tags: tags, lines: 2)
        }.previewLayout(.fixed(width: 200, height: 250))
        .padding()
    }
}
