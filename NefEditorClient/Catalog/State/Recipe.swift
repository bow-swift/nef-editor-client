import Foundation

struct Recipe: Equatable {
    let title: String
    let description: String
    let dependencies: [Dependency]
    
    func copy(
        title: String? = nil,
        description: String? = nil,
        dependencies: [Dependency]? = nil
    ) -> Recipe {
        Recipe(
            title: title ?? self.title,
            description: description ?? self.description,
            dependencies: dependencies ?? self.dependencies)
    }
}
