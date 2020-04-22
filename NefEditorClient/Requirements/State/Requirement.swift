import GitHub

enum Requirement: Equatable {
    case version(Tag)
    case branch(Branch)
    
    var title: String {
        switch self {
        case .version(let tag): return tag.name
        case .branch(let branch): return branch.name
        }
    }
}

extension Requirement: Identifiable {
    var id: String {
        title
    }
}
