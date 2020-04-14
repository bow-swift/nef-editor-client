import Foundation

struct Recipe {
    let title: String
    let description: String
    let lastModified: Date
    let dependencies: [Dependency]
}
