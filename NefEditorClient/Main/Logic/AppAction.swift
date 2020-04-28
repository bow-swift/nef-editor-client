import BowOptics

enum AppAction: AutoPrism {
    case addRecipe
    case edit(item: CatalogItem)
    case dismissEdition
    case saveRecipe(title: String, description: String)
    case duplicate(item: CatalogItem)
    case remove(item: CatalogItem)
    case select(item: CatalogItem)
    
    case searchDependency
    case searchAction(SearchAction)
}
