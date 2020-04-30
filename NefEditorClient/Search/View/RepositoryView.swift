import SwiftUI
import GitHub

struct RepositoryView: View {
    let repository: Repository
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                Text(self.repository.name)
                    .titleStyle()
                    .padding(.bottom, 4)
                
                Text(self.repository._description ?? "No description")
                
                Spacer()
                
                HStack(alignment: .lastTextBaseline) {
                    HStack {
                        AvatarView(avatar: self.repository.owner.avatarUrl)
                            .frame(width: 24, height: 24)
                            .mask(Circle())
                        Text(self.repository.owner.login)
                    }
                    
                    Spacer()
                    
                    self.labeledImage(
                        "star.fill",
                        tint: .yellow,
                        text: "\(self.repository.stargazersCount)")
                }
            }.padding()
        }
    }
    
    private func labeledImage(
        _ image: String,
        tint: Color? = nil,
        text: String) -> some View {
        
        HStack {
            Image(systemName: image).foregroundColor(tint)
            Text(text)
        }
    }
}

struct RepositoryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RepositoryView(repository: sampleRepo)
                .frame(maxWidth: 300, maxHeight: 200)
                .aspectRatio(4/3, contentMode: .fit)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
