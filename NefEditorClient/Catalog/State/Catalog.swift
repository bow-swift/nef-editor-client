import GitHub

struct Catalog {
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
                            url: "https://github.com/bow-swift/bow",
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
                            url: "https://github.com/bow-swift/bow",
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
}
