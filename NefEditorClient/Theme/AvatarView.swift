import SwiftUI

struct AvatarView: View {
    let avatar: String
    
    var body: some View {
        // GitHub API has a parameter 's' that lets us control the size of the received image
        if let url = URL(string: avatar + "&s=24") {
            return AnyView(
                URLImage(url: url, placeholder: Image.person)
            )
        } else {
            return AnyView(
                Image.person
            )
        }
    }
}
