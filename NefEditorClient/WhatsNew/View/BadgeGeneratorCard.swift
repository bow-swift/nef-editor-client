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
                Images.app.resizable().frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(lineWidth: 4).foregroundColor(.nef))
                Images.plus
                    .font(.body).foregroundColor(.red)
                    .padding()
                Images.github.resizable().frame(width: 120, height: 120)
                    .clipShape(Circle())
            }.padding(24)
            
            Divider().padding(.leading, 24).padding(.trailing, 24)
            
            HStack {
                Spacer()
                Images.Badge.platform.opacity(0.5)
                Images.Badge.actions.opacity(0.5)
                Images.Badge.nef
                Spacer()
            }
            
            Text("You can attach a nef badge to your GitHub Swift repo, to let users try your project directly in their iPads.")
                .cardBodyStyle()
                .multilineTextAlignment(.center)
                .padding(.init(top: 18, leading: 44, bottom: 0, trailing: 44))
            
            Button(action: { self.handle(.openGenerator) }) {
                HStack {
                    Images.url.resizable().frame(width: 30, height: 30)
                    Text("Open badge generator")
                        .font(.body)
                        .foregroundColor(Color.blue)
                }
            }.padding(44)
        }
    }
    
    enum Images {
        static let app = Image("nef-logo")
        static let github = Image("github-logo")
        static let plus = Image(systemName: "suit.heart.fill")
        static let url = Image(systemName: "wand.and.stars")
        
        enum Badge {
            static let platform = Image("bow-platform-badge")
            static let actions = Image("bow-actions-badge")
            static let nef = Image("nef-playgrounds-badge")
        }
    }
}
