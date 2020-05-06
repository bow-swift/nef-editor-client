import GitHub
import Bow
import BowArch
import BowOptics
import SwiftUI

typealias AppComponent<Catalog: View, Search: View, Detail: View, Edit: View> = StoreComponent<API.Config, AppState, AppAction, AppView<Catalog, Search, Detail, Edit>>

func appComponent() -> AppComponent<CatalogComponent, SearchComponent, CatalogDetailComponent, EditComponent> {
    let initialState = AppState(
        panelState: .catalog,
        editState: .notEditing,
        searchState: SearchState(loadingState: .initial, modalState: .noModal),
        catalog: Catalog.initial,
        selectedItem: nil)
    let config = API.Config(basePath: "https://api.github.com")
    
    return AppComponent(
        initialState: initialState,
        environment: config,
        dispatcher: appDispatcher
    ) { state, handle in
        AppView(
            state: state,
            
            catalog: catalogComponent(catalog: state.catalog, selectedItem: state.selectedItem)
                .using(handle, transformInput: AppAction.prism(for: AppAction.catalogAction)),
            
            search: searchComponent(config: config, state: state.searchState)
                .using(handle, transformInput: AppAction.prism(for: AppAction.searchAction)),
            
            detail: catalogDetailComponent(state: state.selectedItem)
                .using(handle, transformInput: AppAction.prism(for: AppAction.catalogDetailAction)),
            
            edit: editComponent(state: state.editState)
                .using(handle, transformInput: AppAction.prism(for: AppAction.editAction)),
            
            handle: handle)
    }
}
