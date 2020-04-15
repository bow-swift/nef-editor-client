import SwiftUI

struct DependencyView: View {
    let dependency: Dependency
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 8) {
                Text(dependency.repository)
                    .font(.title)
                
                Text(dependency.url)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            TagView(tag: TagViewModel(text: dependency.requirement.title))
        }.padding()
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
