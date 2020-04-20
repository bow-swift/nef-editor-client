import Foundation

struct Recipe: Equatable {
    let title: String
    let description: String
    let lastModified: Date
    let dependencies: [Dependency]
}
