import BowOptics

enum AppAction: AutoPrism {
    case catalogAction(CatalogAction)
    case searchAction(SearchAction)
    case editAction(EditAction)
    case catalogDetailAction(CatalogDetailAction)
    case generationAction(GenerationAction)
    case creditsAction(CreditsAction)
    case faqAction(FAQAction)
    case initialLoad
    case dismissModal
    case showICloudAlert
    case dismissICloudAlert
    case showSettings
    case showCredits
    case showFAQ
}
