import SwiftUI

struct BadgeGeneratorCard: View {
    let handle: (WhatsNewAction) -> Void
    
    var body: some View {
        VStack {
            Text("Badge generator")
                .cardTitleStyle()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.init(top: 24, leading: 24, bottom: 0, trailing: 24))
            
            HStack {
                Image.appIcon.resizable().frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(lineWidth: 4).foregroundColor(.nef))
                Image.heart
                    .font(.body).foregroundColor(.red)
                    .padding()
                Image.githubIcon.resizable().frame(width: 120, height: 120)
                    .clipShape(Circle())
            }.padding(24)
            
            Divider().padding(.horizontal, 24)
            
            HStack {
                Spacer()
                Image.badgePlatform.opacity(0.5)
                Image.badgeActions.opacity(0.5)
                Image.badgeNef
                Spacer()
            }
            
            Text("You can attach a nef badge to your GitHub Swift repo, to let users try your project directly in their iPads.")
                .cardBodyStyle()
                .multilineTextAlignment(.center)
                .padding(.init(top: 18, leading: 44, bottom: 0, trailing: 44))
            
            Button(action: { self.handle(.openGenerator) }) {
                HStack {
                    Image.wand.resizable().frame(width: 30, height: 30)
                    Text("Open badge generator")
                        .font(.body)
                        .foregroundColor(Color.blue)
                }
            }.padding(44)
        }
    }
}
