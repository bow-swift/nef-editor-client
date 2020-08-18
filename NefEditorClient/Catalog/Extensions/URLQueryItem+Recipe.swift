import Foundation

extension Array where Element == URLQueryItem {
    
    var recipe: Recipe? {
        guard let title = value(of: "name"),
              let dependency = dependency else { return nil }
        
        return .init(title: title,
                     description: value(of: "description") ?? "",
                     dependencies: [dependency])
    }
    
    // MARK: Recipe <helpers>
    private var dependency: Dependency? {
        guard let repository = value(of: "name"),
              let url = value(of: "url"),
              let owner = value(of: "owner"),
              let avatar = value(of: "avatar"),
              let requirement = requirement else { return nil }
        
        return .init(repository: repository,
                     owner: owner,
                     url: url,
                     avatar: avatar,
                     requirement: requirement,
                     products: products)
    }
    
    private var requirement: Requirement? {
        if let branch = value(of: "branch") {
            return .branch(.init(name: branch))
        } else if let tag = value(of: "tag") {
            return .version(.init(name: tag))
        } else {
            return nil
        }
    }
    
    private var products: Dependency.Products {
        let products = values(of: "products").map { $0.trimmingCharacters(in: .whitespaces) }
        return products.count > 0 ? .selected(names: products) : .all
    }
    
    // MARK: URLQueryItem <helpers>
    private func value(of key: String) -> String? {
        first { $0.name == key }?.value
    }
    
    private func values(of key: String) -> [String] {
        filter { $0.name == "\(key)[]" }
            .compactMap(\.value)
    }
}
