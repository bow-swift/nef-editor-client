import BowOptics

struct AppState {
    let panelState: PanelState
    let editState: EditState
    let searchState: SearchState
    let catalog: Catalog
    let selectedItem: CatalogItem
    
    var shouldShowModal: Bool {
        editState != .notEditing ||
        searchState.modalState != .noModal
    }
    
    func copy(
        panelState: PanelState? = nil,
        editState: EditState? = nil,
        searchState: SearchState? = nil,
        catalog: Catalog? = nil,
        selectedItem: CatalogItem? = nil
    ) -> AppState {
        AppState(
            panelState: panelState ?? self.panelState,
            editState: editState ?? self.editState,
            searchState: searchState ?? self.searchState,
            catalog: catalog ?? self.catalog,
            selectedItem: selectedItem ?? self.selectedItem)
    }
    
    static var searchStateLens: Lens<AppState, SearchState> {
        Lens(
            get: { app in app.searchState },
            set: { app, search in app.copy(searchState: search) }
        )
    }
    
    static var modalStateLens: Lens<AppState, SearchModalState> {
        searchStateLens + SearchState.modalStateLens
    }
    
    static var catalogLens: Lens<AppState, Catalog> {
        Lens(
            get: { app in app.catalog },
            set: { app, catalog in app.copy(catalog: catalog) }
        )
    }
}
