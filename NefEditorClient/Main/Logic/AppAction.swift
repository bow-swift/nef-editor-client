import BowOptics

enum AppAction: AutoPrism {
    case catalogAction(CatalogAction)
    case searchAction(SearchAction)
    case editAction(EditAction)
    case catalogDetailAction(CatalogDetailAction)
    case generationAction(GenerationAction)
    case creditsAction(CreditsAction)
    case faqAction(FAQAction)
    case whatsNewAction(WhatsNewAction)
    case initialLoad(DeepLinkAction)
    case dismissModal
    case showICloudAlert
    case dismissICloudAlert
    case showSettings
    case showCredits
    case showFAQ
    case showWhatsNew
}
