import BowArch

typealias CatalogComponent = StoreComponent<Any, Catalog, CatalogAction, RecipeCatalogView>

func catalogComponent(state: Catalog) -> CatalogComponent {
    CatalogComponent(
        initialState: state,
        environment: (),
        dispatcher: .empty(),
        render: RecipeCatalogView.init)
}
