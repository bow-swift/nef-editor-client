import BowArch

typealias CatalogDetailComponent = StoreComponent<Any, CatalogItem, CatalogDetailAction, CatalogItemDetailView>

func catalogDetailComponent(state: CatalogItem) -> CatalogDetailComponent {
    CatalogDetailComponent(
        initialState: state,
        render: CatalogItemDetailView.init)
}
