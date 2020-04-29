import BowArch

typealias CatalogComponent = StoreComponent<Any, Catalog, CatalogAction, RecipeCatalogView>

func catalogComponent(state: Catalog) -> CatalogComponent {
    CatalogComponent(
        initialState: state,
        render: RecipeCatalogView.init)
}
