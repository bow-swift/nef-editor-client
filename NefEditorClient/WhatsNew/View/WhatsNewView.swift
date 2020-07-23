import SwiftUI

struct WhatsNewView: View {
    @Environment(\.colorScheme) var colorScheme
    let handle: (WhatsNewAction) -> Void
    
    init(handle: @escaping (WhatsNewAction) -> Void) {
        self.handle = handle
    }
    
    var body: some View {
        EmptyView()
    }
}

#if DEBUG
struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WhatsNewView() { _ in }
        }.previewLayout(.fixed(width: 800, height: 800))
    }
}
#endif
