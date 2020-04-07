import SwiftUI

struct RequirementView: View {
    let requirement: Requirement
    
    var body: some View {
        HStack {
            Image(systemName: self.requirement.iconName)
            Text(self.requirement.title)
            Spacer()
        }.padding()
    }
}

private extension Requirement {
    var iconName: String {
        switch self {
        case .version: return "tag"
        case .branch: return "arrow.branch"
        }
    }
    
    var title: String {
        switch self {
        case .version(let tag): return tag.name
        case .branch(let branch): return branch.name
        }
    }
}

struct RequirementView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RequirementView(requirement: version)
            
            RequirementView(requirement: branch)
        }.frame(width: 400)
        .previewLayout(.sizeThatFits)
    }
}
