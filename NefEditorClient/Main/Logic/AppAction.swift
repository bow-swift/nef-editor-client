import BowOptics

enum AppAction: AutoPrism {
    case catalogAction(CatalogAction)
    case edit(item: CatalogItem)
    case dismissModal
    case saveRecipe(title: String, description: String)
    case searchDependency
    case searchAction(SearchAction)
}
