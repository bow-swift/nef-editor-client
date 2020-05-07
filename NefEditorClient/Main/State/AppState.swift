import BowOptics

struct AppState: Equatable {
    let panelState: PanelState
    let editState: EditState
    let searchState: SearchState
    let catalog: Catalog
    let selectedItem: CatalogItem?
    let iCloudStatus: ICloudStatus
    
    func copy(
        panelState: PanelState? = nil,
        editState: EditState? = nil,
        searchState: SearchState? = nil,
        catalog: Catalog? = nil,
        selectedItem: CatalogItem?? = nil,
        iCloudStatus: ICloudStatus? = nil
    ) -> AppState {
        AppState(
            panelState: panelState ?? self.panelState,
            editState: editState ?? self.editState,
            searchState: searchState ?? self.searchState,
            catalog: catalog ?? self.catalog,
            selectedItem: selectedItem ?? self.selectedItem,
            iCloudStatus: iCloudStatus ?? self.iCloudStatus
        )
    }
    
    static var searchStateLens: Lens<AppState, SearchState> {
        Lens(
            get: { app in app.searchState },
            set: { app, search in app.copy(searchState: search) }
        )
    }
    
    static var catalogLens: Lens<AppState, (Catalog, CatalogItem?)> {
        Lens(
            get: { app in (app.catalog, app.selectedItem) },
            set: { app, new in app.copy(catalog: new.0, selectedItem: new.1) }
        )
    }
    
    static var editStateLens: Lens<AppState, EditState> {
        Lens(
            get: { app in app.editState },
            set: { app, edit in app.copy(editState: edit) }
        )
    }
    
    static var selectedItemLens: Lens<AppState, CatalogItem?> {
        Lens(
            get: { app in app.selectedItem },
            set: { app, item in app.copy(selectedItem: item) })
    }
}
