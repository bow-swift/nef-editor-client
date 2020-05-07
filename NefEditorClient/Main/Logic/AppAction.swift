import BowOptics

enum AppAction: AutoPrism {
    case catalogAction(CatalogAction)
    case searchAction(SearchAction)
    case editAction(EditAction)
    case catalogDetailAction(CatalogDetailAction)
    case initialLoad
    case dismissModal
}
