import SwiftUI
import GitHub
import NefAPI
import Bow
import BowArch
import BowOptics
import BowEffects

typealias AppComponent<Catalog: View, Search: View, Detail: View, Modal: View> =
    StoreComponent<
        AppDependencies,
        AppState,
        AppAction,
        AppView<Catalog, Search, Detail, Modal>
    >

typealias AppComponentView = AppComponent<CatalogComponent, SearchComponent, CatalogDetailComponent, AppModalComponent>

func appComponent(urlContexts: Set<UIOpenURLContext>) -> AppComponentView {
    let deepLinkState = urlContexts.first.map(\.url).flatMap(schemeRecipe).flatMap(DeepLinkState.recipe) ?? .none
    return appComponent(deepLinkState: deepLinkState)
}

func appComponent(userActivity: NSUserActivity) -> AppComponentView {
    let deepLinkState = userActivity.webpageURL.flatMap(schemeRecipe).flatMap(DeepLinkState.recipe) ?? .none
    return appComponent(deepLinkState: deepLinkState)
}

fileprivate func appComponent(deepLinkState: DeepLinkState) -> AppComponentView {
    let ref = IORef<Error, [Recipe]?>.unsafe(nil)
    let gitHubConfig = makeGitHubConfig()
    let nefConfig = makeNefConfig()
    let persistence = ICloudPersistence()
    let dependencies = AppDependencies(persistence: persistence,
                                       gitHubConfig: gitHubConfig,
                                       nefConfig: nefConfig)
    
    let initialState = AppState(
        panelState: .catalog,
        modalState: .noModal,
        searchState: SearchState(loadingState: .initial, modalState: .noModal),
        deepLinkState: deepLinkState,
        catalog: Catalog.initial,
        selectedItem: nil,
        iCloudStatus: .enabled,
        iCloudAlert: .hidden,
        authenticationState: .unauthenticated)
    
    return AppComponent (
        initialState: initialState,
        environment: dependencies,
        dispatcher: appDispatcher
    ) { state, handle in
        AppView(
            state: state,
            
            catalog: catalogComponent(catalog: state.catalog, selectedItem: state.selectedItem)
                .using(handle, transformInput: AppAction.prism(for: AppAction.catalogAction)),
            
            search: searchComponent(config: gitHubConfig, state: state.searchState)
                .using(handle, transformInput: AppAction.prism(for: AppAction.searchAction)),
            
            detail: { item in
                catalogDetailComponent(state: item)
                    .using(handle, transformInput: AppAction.prism(for: AppAction.catalogDetailAction))
            },
            
            modal: { state in
                appModalComponent(state: state)
                    .using(handle, transformInput: Prism.identity)
            },
            
            handle: handle)
    }.onEffect { component in
        let oldRecipes = IO<Error, [Recipe]?>.var()
        let newRecipes = component.store().state.catalog.userCreated.items.map(\.recipe)
        
        return binding(
            oldRecipes <- ref.get(),
            |<-((oldRecipes.get != newRecipes) ?
                persist(state: component.store().state).provide(persistence) :
                IO.lazy()),
            |<-ref.set(newRecipes),
            yield: ())
    }
}

func makeGitHubConfig() -> GitHub.API.Config {
    GitHub.API.Config(basePath: "https://api.github.com")
}

func makeNefConfig() -> NefAPI.API.Config {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 420
    configuration.timeoutIntervalForResource = 420
    
    let session = URLSession(configuration: configuration)
    
    return NefAPI.API.Config(
        basePath: "https://nef.47deg.com",
        session: session)
        .appending(contentType: .json)
}
