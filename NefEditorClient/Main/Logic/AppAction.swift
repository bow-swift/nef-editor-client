enum AppAction {
    case addRecipe
    case edit(item: CatalogItem)
    case dismissEdition
    case saveRecipe(title: String, description: String)
    case searchDependency
    case select(item: CatalogItem)
}
