import SwiftUI

struct WhatsNewView: View {
    @Environment(\.colorScheme) var colorScheme
    let handle: (WhatsNewAction) -> Void
    
    var body: some View {
        VStack {
            whatsNewCard()
            Spacer()
            Button("Got it!", action: { self.handle(.dismiss) })
                .frame(maxWidth: .infinity)
                .buttonStyle(TextButtonStyle())
                .padding()
            
        }.navigationBarTitle("What's New", displayMode: .inline)
    }
    
    private func whatsNewCard() -> some View {
        BadgeGeneratorCard(handle: handle)
    }
}

#if DEBUG
struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WhatsNewView() { _ in }.environment(\.colorScheme, .light)
            WhatsNewView() { _ in }.preferredColorScheme(.dark)
        }.previewLayout(.fixed(width: 800, height: 800))
    }
}
#endif
