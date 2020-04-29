import BowOptics

enum AppAction: AutoPrism {
    case catalogAction(CatalogAction)
    case searchAction(SearchAction)
    case editAction(EditAction)
    case dismissModal
    
    case edit(item: CatalogItem)
    case searchDependency
}
