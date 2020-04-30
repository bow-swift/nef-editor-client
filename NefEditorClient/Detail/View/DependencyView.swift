import SwiftUI

struct DependencyView: View {
    let dependency: Dependency
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 8) {
                Text(dependency.repository)
                    .font(.body)
                
                HStack {
                    AvatarView(avatar: dependency.avatar)
                        .frame(width: 24, height: 24)
                        .mask(Circle())
                    
                    Text(dependency.owner)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            TagView(tag: TagViewModel(text: dependency.requirement.title))
        }.padding(.vertical, 4)
    }
}

struct DependencyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DependencyView(dependency: bowDependency)
            DependencyView(dependency: bowArchDependency)
        }.previewLayout(.sizeThatFits)
    }
}
