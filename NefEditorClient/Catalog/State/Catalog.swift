import GitHub

struct Catalog: Equatable {
    let featured: CatalogSection
    let userCreated: CatalogSection
    
    var sections: [CatalogSection] {
        [featured, userCreated]
    }
    
    static var initial: Catalog {
        let bow = CatalogItem.featured(
            FeaturedRecipe(
                recipe: Recipe(
                    title: "FP with Bow",
                    description: "Get all modules in Bow 0.7.0 to write FP in Swift",
                    dependencies: [
                        Dependency(
                            repository: "bow",
                            owner: "bow-swift",
                            url: "https://github.com/bow-swift/bow",
                            avatar: "https://avatars3.githubusercontent.com/u/44965417?v=4",
                            requirement: .version(Tag(name: "0.7.0")))
                ]),
                backgroundImage: "bow-background",
                textColor: .white)
        )
        
        let bowMaster = CatalogItem.featured(
            FeaturedRecipe(
                recipe: Recipe(
                    title: "FP with Bow",
                    description: "Use the latest enhancements in Bow master branch",
                    dependencies: [
                        Dependency(
                            repository: "bow",
                            owner: "bow-swift",
                            url: "https://github.com/bow-swift/bow",
                            avatar: "https://avatars3.githubusercontent.com/u/44965417?v=4",
                            requirement: .branch(Branch(name: "master")))
                ]),
                backgroundImage: "bow-background",
                textColor: .white)
        )
        
        let featured = CatalogSection(
            title: "Featured",
            items: [bow, bowMaster])
        let myRecipes = CatalogSection(
            title: "My recipes",
            action: CatalogSectionAction(icon: "plus", action: .addRecipe),
            items: [])
        
        return Catalog(featured: featured, userCreated: myRecipes)
    }
    
    func appending(_ item: CatalogItem) -> Catalog {
        Catalog(featured: featured, userCreated: userCreated.appending(item))
    }
    
    func replacing(_ item: CatalogItem, by newItem: CatalogItem) -> Catalog {
        Catalog(featured: featured, userCreated: userCreated.replacing(item, by: newItem))
    }
    
    func removing(_ item: CatalogItem) -> Catalog {
        Catalog(featured: featured, userCreated: userCreated.removing(item))
    }
}
