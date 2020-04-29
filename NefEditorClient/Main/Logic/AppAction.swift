import BowOptics

enum AppAction: AutoPrism {
    case catalogAction(CatalogAction)
    case edit(item: CatalogItem)
    case dismissModal
    case saveRecipe(title: String, description: String)
    case searchDependency
    case searchAction(SearchAction)
    
    static var catalogPrism: Prism<AppAction, CatalogAction> = Prism(
        extract: { app in
            guard case let .catalogAction(action) = app else {
                return nil
            }
            return action
        },
        embed: AppAction.catalogAction
    )
    
    static var searchPrism: Prism<AppAction, SearchAction> = Prism(
        extract: { app in
            guard case let .searchAction(action) = app else {
                return nil
            }
            return action
        },
        embed: AppAction.searchAction
    )
}
