enum AppAction {
    case addRecipe
    case edit(item: CatalogItem)
    case dismissEdition
    case saveRecipe(title: String, description: String)
    case duplicate(item: CatalogItem)
    case remove(item: CatalogItem)
    case searchDependency
    case select(item: CatalogItem)
}
