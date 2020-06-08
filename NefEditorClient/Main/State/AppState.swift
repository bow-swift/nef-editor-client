import BowOptics

struct AppState: Equatable {
    let panelState: PanelState
    let modalState: AppModalState
    let searchState: SearchState
    let deepLinkState: DeepLinkState
    let catalog: Catalog
    let selectedItem: CatalogItem?
    let iCloudStatus: ICloudStatus
    let iCloudAlert: ICloudAlert
    let authenticationState: AuthenticationState
    
    func copy(
        panelState: PanelState? = nil,
        modalState: AppModalState? = nil,
        searchState: SearchState? = nil,
        deepLinkState: DeepLinkState? = nil,
        catalog: Catalog? = nil,
        selectedItem: CatalogItem?? = nil,
        iCloudStatus: ICloudStatus? = nil,
        iCloudAlert: ICloudAlert? = nil,
        authenticationState: AuthenticationState? = nil
    ) -> AppState {
        AppState(
            panelState: panelState ?? self.panelState,
            modalState: modalState ?? self.modalState,
            searchState: searchState ?? self.searchState,
            deepLinkState: deepLinkState ?? self.deepLinkState,
            catalog: catalog ?? self.catalog,
            selectedItem: selectedItem ?? self.selectedItem,
            iCloudStatus: iCloudStatus ?? self.iCloudStatus,
            iCloudAlert: iCloudAlert ?? self.iCloudAlert,
            authenticationState: authenticationState ?? self.authenticationState
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
    
    static var selectedItemLens: Lens<AppState, CatalogItem?> {
        Lens(
            get: { app in app.selectedItem },
            set: { app, item in app.copy(selectedItem: item) })
    }
}
