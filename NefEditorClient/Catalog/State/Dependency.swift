struct Dependency: Equatable, Codable {
    let repository: String
    let owner: String
    let url: String
    let avatar: String
    let requirement: Requirement
}
