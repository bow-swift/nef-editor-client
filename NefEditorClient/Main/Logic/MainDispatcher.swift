import Bow
import BowEffects
import BowArch
import GitHub
import UIKit

typealias MainDispatcher = StateDispatcher<Persistence, AppState, AppAction>

let mainDispatcher = MainDispatcher.workflow { action in
    switch action {
    case .dismissModal:
        return [EnvIO.pure(dismissModal())^]
        
    case .showICloudAlert:
        return [EnvIO.pure(showICloudAlert())^]
        
    case .dismissICloudAlert:
        return [EnvIO.pure(dismissICloudAlert())^]
    
    case .showSettings:
        return [showSettings().contramap(id)]
        
    case .showCredits:
        return [EnvIO.pure(showCredits())^]
        
    case .showFAQ:
        return [EnvIO.pure(showFAQ())^]
        
    case .searchAction(let action):
        switch action {
        case .cancelSearch:
            return [EnvIO.pure(cancelSearch())^]
        default:
            return []
        }
        
    case .catalogAction(_), .editAction(_), .catalogDetailAction(_), .creditsAction(_), .generationAction(_), .faqAction(_):
        return []
        
    case .initialLoad:
        return [initialLoad()]
        
    case .schema(let recipe):
        return generateNewRecipe(recipe)
    }
}


let addDependencyDispatcher = StateDispatcher<Any, AppState, RepositoryDetailAction>.pure { input in
    switch input {
    case let .dependencySelected(requirement, from: repository):
        return addDependency(requirement, from: repository)
        
    case .loadRequirements(_), .dismissDetails:
        return .modify(id)^
    }
}

func dismissModal() -> State<AppState, Void> {
    .modify { state in
        state.copy(
            modalState: .noModal,
            searchState: state.searchState.copy(modalState: .noModal))
    }^
}

func showICloudAlert() -> State<AppState, Void> {
    .modify { state in
        state.copy(iCloudAlert: .shown)
    }^
}

func dismissICloudAlert() -> State<AppState, Void> {
    .modify { state in
        state.copy(iCloudAlert: .hidden)
    }^
}

func showSettings() -> EnvIO<Any, Error, State<AppState, Void>> {
    EnvIO.later(.main) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }.as(dismissICloudAlert())^
}

func showCredits() -> State<AppState, Void> {
    .modify { state in
        state.copy(modalState: .credits)
    }^
}

func showFAQ() -> State<AppState, Void> {
    .modify { state in
        state.copy(modalState: .faq)
    }^
}

func cancelSearch() -> State<AppState, Void> {
    .modify { state in
        state.copy(panelState: .catalog)
    }^
}

func addDependency(
    _ requirement: Requirement,
    from repository: Repository
) -> State<AppState, Void> {
    .modify { state in
        if let selected = state.selectedItem {
            let dependency = Dependency(repository: repository.name,
                                        owner: repository.owner.login,
                                        url: repository.htmlUrl,
                                        avatar: repository.owner.avatarUrl,
                                        requirement: requirement)
            let newRecipe = selected.appending(dependency: dependency)
            
            return state.copy(
                catalog: state.catalog.replacing(selected, by: newRecipe),
                selectedItem: newRecipe)
        } else {
            return state
        }
    }^
}

func addNewRecipe(_ recipe: Recipe) -> State<AppState, Void> {
    .modify { (state: AppState) in
        let catalogItem: CatalogItem = .regular(recipe)
        let catalog = state.catalog.appending(catalogItem)
        return state.copy(catalog: catalog, selectedItem: catalogItem)
    }^
}

func persist(state: AppState) -> EnvIO<Persistence, Error, Void> {
    EnvIO.accessM { persistence in
        persistence.saveUserRecipes(state.catalog.userCreated.items.map(\.recipe))
    }
}

func initialLoad() -> EnvIO<Persistence, Error, State<AppState, Void>> {
    let recipes = EnvIO<Persistence, Error, [Recipe]>.var()
    let persistenceEnabled = EnvIO<Persistence, Error, ICloudStatus>.var()
    
    return binding(
        (recipes, persistenceEnabled) <- parallel(
            fetchRecipes(),
            isICloudAvailable()),
        yield: .modify { state in
            let newCatalog = state.catalog.userCreated(recipes.get)
            return state.copy(catalog: newCatalog, iCloudStatus: persistenceEnabled.get)
        }^
    )^
}

func generateNewRecipe(_ recipe: Recipe) -> [EnvIO<Persistence, Error, State<AppState, Void>>] {
    [
        EnvIO.pure(addNewRecipe(recipe))^,
        EnvIO.pure(generatePlayground(for: .regular(recipe)))^,
    ]
}

func fetchRecipes() -> EnvIO<Persistence, Error, [Recipe]> {
    EnvIO.accessM { persistence in
        persistence.loadUserRecipes()
    }
}

func isICloudAvailable() -> EnvIO<Persistence, Error, ICloudStatus> {
    EnvIO.access(\.isPersistenceAvailable).map { isAvailable in
        isAvailable ? .enabled : .disabled
    }^
}
