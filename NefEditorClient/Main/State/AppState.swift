import BowOptics

struct AppState {
    let panelState: PanelState
    let editState: EditState
    let searchState: SearchState
    let catalog: Catalog
    let selectedItem: CatalogItem
    
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
    
    static var catalogLens: Lens<AppState, Catalog> {
        Lens(
            get: { app in app.catalog },
            set: { app, catalog in app.copy(catalog: catalog) }
        )
    }
    
    static var editStateLens: Lens<AppState, EditState> {
        Lens(
            get: { app in app.editState },
            set: { app, edit in app.copy(editState: edit) }
        )
    }
}
