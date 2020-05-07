import BowOptics

enum AppAction: AutoPrism {
    case catalogAction(CatalogAction)
    case searchAction(SearchAction)
    case editAction(EditAction)
    case catalogDetailAction(CatalogDetailAction)
    case creditsAction(CreditsAction)
    case initialLoad
    case dismissModal
    case showAlert
    case dismissAlert
    case showSettings
    case showCredits
}
