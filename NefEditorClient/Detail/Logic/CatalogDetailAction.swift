enum CatalogDetailAction {
    case edit(item: CatalogItem)
    case searchDependency
    case remove(Dependency)
    case dismissDetail
    case generatePlayground(for: CatalogItem)
}
