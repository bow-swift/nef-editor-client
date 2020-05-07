import GitHub

enum Requirement: Equatable, Codable {
    case version(Tag)
    case branch(Branch)
    
    var title: String {
        switch self {
        case .version(let tag): return tag.name
        case .branch(let branch): return branch.name
        }
    }
    
    enum Keys: CodingKey {
        case version
        case branch
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        if let tag = try? container.decode(Tag.self, forKey: .version) {
            self = .version(tag)
        } else if let branch = try? container.decode(Branch.self, forKey: .branch) {
            self = .branch(branch)
        } else {
            throw Swift.DecodingError.dataCorrupted(
                Swift.DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Error decoding Requirement")
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        switch self {
        case let .version(tag):
            try container.encode(tag, forKey: .version)
        case let .branch(branch):
            try container.encode(branch, forKey: .branch)
        }
    }
}

extension Requirement: Identifiable {
    var id: String {
        title
    }
}
