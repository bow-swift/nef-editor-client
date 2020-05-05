import GitHub
import Bow
import BowArch
import BowOptics
import SwiftUI

typealias AppComponent<Catalog: View, Search: View, Detail: View, Edit: View> = StoreComponent<API.Config, AppState, AppAction, AppView<Catalog, Search, Detail, Edit>>

typealias CatalogChild = StoreComponent<API.Config, AppState, AppAction, RecipeCatalogView>
typealias SearchChild = StoreComponent<API.Config, AppState, AppAction, SearchView<SearchDetailChild>>
typealias DetailChild = StoreComponent<API.Config, AppState, AppAction, CatalogItemDetailView>
typealias EditChild = StoreComponent<API.Config, AppState, AppAction, EditRecipeMetadataView>

func appComponent() -> AppComponent<CatalogChild, SearchChild, DetailChild, EditChild> {
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
                .lift(initialState: state,
                      environment: config,
                      transformEnvironment: id,
                      transformState: AppState.catalogLens,
                      transformInput: AppAction.prism(for: AppAction.catalogAction))
                .using(handle),
            
            search: searchComponent(config: config, state: state.searchState)
                .lift(
                    initialState: state,
                    transformState: AppState.searchStateLens,
                    transformInput: AppAction.prism(for: AppAction.searchAction))
                .using(handle),
            
            detail: catalogDetailComponent(state: state.selectedItem)
                .lift(initialState: state,
                      environment: config,
                      transformEnvironment: id,
                      transformState: AppState.selectedItemLens,
                      transformInput: AppAction.prism(for: AppAction.catalogDetailAction))
                .using(handle),
            
            edit: editComponent(state: state.editState)
                .lift(initialState: state,
                      environment: config,
                      transformEnvironment: id,
                      transformState: AppState.editStateLens,
                      transformInput: AppAction.prism(for: AppAction.editAction))
                .using(handle),
            
            handle: handle)
    }
}
