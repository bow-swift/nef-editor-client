enum CatalogAction {
    case addRecipe
    case duplicate(item: CatalogItem)
    case remove(item: CatalogItem)
    case select(item: CatalogItem)
}
