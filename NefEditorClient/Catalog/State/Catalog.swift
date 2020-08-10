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
                    description: "Get all modules in Bow 0.8.0 to write FP in Swift",
                    dependencies: [
                        Dependency(
                            repository: "bow",
                            owner: "bow-swift",
                            url: "https://github.com/bow-swift/bow",
                            avatar: "https://avatars3.githubusercontent.com/u/44965417?v=4",
                            requirement: .version(Tag(name: "0.8.0")))
                ]),
                backgroundImage: "bow-background",
                textColor: .white)
        )
        
        let bowArch = CatalogItem.featured(
            FeaturedRecipe(
                recipe: Recipe(
                    title: "Architecture",
                    description: "Try Bow Arch to explore the possibilities of Functional Architecture",
                    dependencies: [
                        Dependency(
                            repository: "bow-arch",
                            owner: "bow-swift",
                            url: "https://github.com/bow-swift/bow-arch",
                            avatar: "https://avatars3.githubusercontent.com/u/44965417?v=4",
                            requirement: .branch(Branch(name: "0.1.0")))
                ]),
                backgroundImage: "bow-arch-background",
                textColor: .black)
        )
        
        let bowLite = CatalogItem.featured(
            FeaturedRecipe(
                recipe: Recipe(
                    title: "FP with Bow Lite",
                    description: "Play with the lightweight version of Bow",
                    dependencies: [
                        Dependency(
                            repository: "bow-lite",
                            owner: "bow-swift",
                            url: "https://github.com/bow-swift/bow-lite",
                            avatar: "https://avatars3.githubusercontent.com/u/44965417?v=4",
                            requirement: .version(Tag(name: "0.1.0")))
                ]),
                backgroundImage: "bow-lite-background",
                textColor: .white)
        )
        
        let featured = CatalogSection(
            title: "Featured",
            items: [bow, bowArch, bowLite])
        let myRecipes = CatalogSection(
            title: "My recipes",
            action: CatalogSectionAction(icon: "plus", action: .addRecipe),
            items: [])
        
        return Catalog(featured: featured, userCreated: myRecipes)
    }
    
    func userCreated(_ recipes: [Recipe]) -> Catalog {
        Catalog(featured: featured,
                userCreated: CatalogSection(title: self.userCreated.title,
                                            action: self.userCreated.action,
                                            items: recipes.map(CatalogItem.regular)))
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
