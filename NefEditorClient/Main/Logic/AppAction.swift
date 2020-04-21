enum AppAction {
    case addRecipe
    case edit(item: CatalogItem)
    case searchDependency
    case select(item: CatalogItem)
}
