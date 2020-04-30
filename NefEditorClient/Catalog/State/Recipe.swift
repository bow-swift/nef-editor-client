import Foundation

struct Recipe: Equatable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let dependencies: [Dependency]
    
    init(id: UUID = UUID(),
         title: String,
         description: String,
         dependencies: [Dependency]) {
        self.id = id
        self.title = title
        self.description = description
        self.dependencies = dependencies
    }
    
    func copy(
        id: UUID? = nil,
        title: String? = nil,
        description: String? = nil,
        dependencies: [Dependency]? = nil
    ) -> Recipe {
        Recipe(
            id: id ?? self.id,
            title: title ?? self.title,
            description: description ?? self.description,
            dependencies: dependencies ?? self.dependencies)
    }
    
    func appending(dependency: Dependency) -> Recipe {
        if !contains(dependency: dependency) {
            return copy(dependencies: self.dependencies + [dependency])
        } else {
            return replacing(dependency: dependency)
        }
    }
    
    private func contains(dependency: Dependency) -> Bool {
        self.dependencies.first { dep in
            dep.url == dependency.url
        } != nil
    }
    
    private func replacing(dependency: Dependency) -> Recipe {
        copy(
            dependencies: self.dependencies.map { dep in
                (dep.url == dependency.url)
                    ? dependency
                    : dep
            }
        )
    }
}
