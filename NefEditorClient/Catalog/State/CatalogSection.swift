struct CatalogSection {
    let title: String
    let action: CatalogSectionAction?
    let items: [CatalogItem]
    
    init(title: String, action: CatalogSectionAction? = nil, items: [CatalogItem]) {
        self.title = title
        self.action = action
        self.items = items
    }
    
    func appending(_ item: CatalogItem) -> CatalogSection {
        CatalogSection(
            title: self.title,
            action: self.action,
            items: self.items + [item])
    }
}

struct CatalogSectionAction {
    let icon: String
    let action: AppAction
}
