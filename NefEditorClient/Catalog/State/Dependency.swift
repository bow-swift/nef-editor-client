struct Dependency: Equatable, Codable, Identifiable {
    let repository: String
    let owner: String
    let url: String
    let avatar: String
    let requirement: Requirement
    
    var id: String {
        "\(url):\(requirement.id)"
    }
}
