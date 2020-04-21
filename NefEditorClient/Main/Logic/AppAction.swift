enum AppAction {
    case addRecipe
    case edit(item: CatalogItem)
    case dismissEdition
    case searchDependency
    case select(item: CatalogItem)
}
