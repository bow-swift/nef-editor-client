import Foundation

struct Recipe: Equatable {
    let title: String
    let description: String
    let dependencies: [Dependency]
}
