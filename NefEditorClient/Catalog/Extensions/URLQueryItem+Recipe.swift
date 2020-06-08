import Foundation

extension Array where Element == URLQueryItem {
    private func value(of key: String) -> String {
        first { $0.name == key }?.value ?? ""
    }
    
    var recipe: Recipe? {
        let title = value(of: "name")
        let description = value(of: "description")
        
        guard !title.isEmpty, let dependency = dependency else { return nil }
        
        return Recipe(title: title,
                      description: description,
                      dependencies: [dependency])
    }
    
    var dependency: Dependency? {
        let repository = value(of: "name")
        let url = value(of: "url")
        let owner = value(of: "owner")
        let avatar = value(of: "avatar")
        
        guard !repository.isEmpty, !url.isEmpty, let requirement = requirement else { return nil }
        
        return .init(repository: repository,
                     owner: owner,
                     url: url,
                     avatar: avatar,
                     requirement: requirement)
    }
    
    var requirement: Requirement? {
        let branch = value(of: "branch")
        let tag = value(of: "tag")
        
        if !branch.isEmpty {
            return .branch(.init(name: branch))
        } else if !tag.isEmpty {
            return .version(.init(name: tag))
        } else {
            return nil
        }
    }
}
