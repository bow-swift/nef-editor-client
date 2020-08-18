struct Dependency: Equatable, Identifiable {
    enum Products: Equatable {
        case all
        case selected(names: [String])
    }
    
    let repository: String
    let owner: String
    let url: String
    let avatar: String
    let requirement: Requirement
    let products: Products
    
    var id: String {
        "\(url):\(requirement.id)"
    }
}

// MARK: - Codable

extension Dependency: Codable { }

extension Dependency.Products: Codable {
    private enum CodingKeys: String, CodingKey {
        case all
        case selected
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .all:
            try container.encode([String](), forKey: .all)
        case .selected(let products):
            try container.encode(products, forKey: .selected)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let _ = try? container.decode([String].self, forKey: .all) {
            self = .all
        } else if let products = try? container.decode([String].self, forKey: .selected) {
            self = .selected(names: products)
        } else {
            fatalError("Dependency.Product decoding could not find a valid key.")
        }
    }
}
