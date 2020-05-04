import BowArch

typealias CatalogComponent = StoreComponent<Any, (Catalog, CatalogItem?), CatalogAction, RecipeCatalogView>

func catalogComponent(catalog: Catalog, selectedItem: CatalogItem?) -> CatalogComponent {
    CatalogComponent(
        initialState: (catalog, selectedItem)) { state, handle in
            RecipeCatalogView(catalog: state.0, selectedItem: state.1, handle: handle)
    }
}
