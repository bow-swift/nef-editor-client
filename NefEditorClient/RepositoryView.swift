import SwiftUI
import GitHub

struct RepositoryView: View {
    let repository: Repository
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 1, y: 1)
            VStack(alignment: .leading, spacing: 8) {
                Text(repository.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 4)
                
                Text(repository._description ?? "No description")
                
                Spacer()
                
                HStack(alignment: .lastTextBaseline) {
                    labeledImage(
                        "person.crop.circle",
                        text: repository.owner.login)
                    
                    Spacer()
                    
                    labeledImage(
                        "star.fill",
                        tint: .yellow,
                        text: "\(repository.stargazersCount)")
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
