import Bow
import BowEffects
import BowOptics
import BowArch
import GitHub

typealias AppDispatcher = StateDispatcher<Persistence, AppState, AppAction>

let appDispatcher: StateDispatcher<AppDependencies, AppState, AppAction> = AppDispatcher.workflow { action in
    switch action {
    case .dismissModal:
        return [EnvIO.pure(dismissModal())^]
    
    case .searchAction(let action):
        switch action {
        case .cancelSearch:
            return [EnvIO.pure(cancelSearch())^]
        default:
            return []
        }
        
    case .catalogAction(_), .editAction(_), .catalogDetailAction(_):
        return []
    case .loadCatalog:
        return [fetchRecipes()]
    }
}.widen(transformEnvironment: \.persistence)
.combine(catalogDispatcher.widen(
    transformEnvironment: id,
    transformInput: AppAction.prism(for: AppAction.catalogAction)))
.combine(editDispatcher.widen(
    transformEnvironment: id,
    transformInput: AppAction.prism(for: AppAction.editAction)))
.combine(catalogDetailDispatcher.widen(
    transformEnvironment: id,
    transformInput: AppAction.prism(for: AppAction.catalogDetailAction)))
.combine(addDependencyDispatcher.widen(
    transformEnvironment: id,
    transformInput: AppAction.prism(for: AppAction.searchAction) +
        SearchAction.prism(for: SearchAction.repositoryDetailAction)))
.combine(searchDispatcher.widen(
    transformEnvironment: \.config,
    transformState: AppState.searchStateLens,
    transformInput: AppAction.prism(for: AppAction.searchAction)))

let prism = AppAction.prism(for: AppAction.searchAction) +
SearchAction.prism(for: SearchAction.repositoryDetailAction)

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
        state.copy(editState: .notEditing,
                   searchState: state.searchState.copy(modalState: .noModal))
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

func persist(state: AppState) -> EnvIO<Persistence, Error, Void> {
    EnvIO.accessM { persistence in
        persistence.saveUserRecipes(state.catalog.userCreated.items.map(\.recipe))
    }
}

func fetchRecipes() -> EnvIO<Persistence, Error, State<AppState, Void>> {
    EnvIO.accessM { persistence in
        persistence.loadUserRecipes()
    }.map { recipes in
        .modify { state in
            let newCatalog = state.catalog.userCreated(recipes)
            return state.copy(catalog: newCatalog)
        }^
    }^
}
