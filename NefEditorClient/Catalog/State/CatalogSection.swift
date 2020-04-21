struct CatalogSection {
    let title: String
    let action: CatalogSectionAction?
    let items: [CatalogItem]
    
    init(title: String, action: CatalogSectionAction? = nil, items: [CatalogItem]) {
        self.title = title
        self.action = action
        self.items = items
    }
}

struct CatalogSectionAction {
    let icon: String
    let action: AppAction
}
