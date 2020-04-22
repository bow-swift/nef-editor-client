struct CatalogSection {
    let title: String
    let action: CatalogSectionAction?
    let items: [CatalogItem]
    
    init(title: String, action: CatalogSectionAction? = nil, items: [CatalogItem]) {
        self.title = title
        self.action = action
        self.items = items
    }
    
    func copy(items: [CatalogItem]) -> CatalogSection {
        CatalogSection(
            title: self.title,
            action: self.action,
            items: items)
    }
    
    func appending(_ item: CatalogItem) -> CatalogSection {
        copy(items: self.items + [item])
    }
    
    func replacing(_ item: CatalogItem, by newItem: CatalogItem) -> CatalogSection {
        copy(items: self.items.map { current in
            (current == item) ? newItem : current
        })
    }
    
    func removing(_ item: CatalogItem) -> CatalogSection {
        copy(items: self.items.filter { current in
            current != item
        })
    }
}

struct CatalogSectionAction {
    let icon: String
    let action: AppAction
}
