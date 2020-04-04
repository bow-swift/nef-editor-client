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
                    self.labeledImage(
                        "person.crop.circle",
                        text: self.repository.owner.login)
                    
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

private let sampleRepo = Repository(
    name: "bow",
    fullName: "bow-swift/bow",
    _description: "🏹 Bow is a library for Typed Functional Programming in Swift",
    _private: false,
    htmlUrl: "https://github.com/bow-swift/bow",
    stargazersCount: 407,
    owner: Owner(login: "bow-swift", avatarUrl: "https://avatars2.githubusercontent.com/u/44965417?s=200&v=4"))

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
