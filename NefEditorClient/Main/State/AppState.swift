struct AppState {
    let panelState: PanelState
    let editState: EditState
    let catalog: Catalog
    let selectedItem: CatalogItem
    
    func copy(
        panelState: PanelState? = nil,
        editState: EditState? = nil,
        catalog: Catalog? = nil,
        selectedItem: CatalogItem? = nil
    ) -> AppState {
        AppState(
            panelState: panelState ?? self.panelState,
            editState: editState ?? self.editState,
            catalog: catalog ?? self.catalog,
            selectedItem: selectedItem ?? self.selectedItem)
    }
}
