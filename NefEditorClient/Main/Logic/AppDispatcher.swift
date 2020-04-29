import Bow
import BowEffects
import BowOptics
import BowArch

typealias AppDispatcher = StateDispatcher<Any, AppState, AppAction>

let appDispatcher = AppDispatcher.pure { action in
    switch action {
    case .catalogAction(_):
        return .modify(id)^
        
    case .edit(item: let item):
        return edit(item: item)
    
    case .dismissModal:
        return dismissModal()
        
    case .saveRecipe(title: let title, description: let description):
        return saveRecipe(title: title, description: description)
        
    case .searchDependency:
        return searchDependency()
    
    case .searchAction(let action):
        switch action {
        case .cancelSearch:
            return cancelSearch()
        default:
            return .modify(id)^
        }
    }
}.combine(catalogDispatcher.widen(
    transformEnvironment: id,
    transformState: Lens.identity,
    transformInput: AppAction.prism(for: AppAction.catalogAction)))

func edit(item: CatalogItem) -> State<AppState, Void> {
    if case let .regular(recipe) = item {
        return .modify { state in
            state.copy(editState: .editRecipe(recipe))
        }^
    } else {
        return .modify(id)^
    }
}

func dismissModal() -> State<AppState, Void> {
    .modify { state in
        state.copy(editState: .notEditing,
                   searchState: state.searchState.copy(modalState: .noModal))
    }^
}

func saveRecipe(title: String, description: String) -> State<AppState, Void> {
    .modify { state in
        switch state.editState {
        case .notEditing: return state
            
        case .newRecipe:
            let recipe = createRecipe(title: title, description: description)
            let newCatalog = state.catalog.appending(recipe)
            return state.copy(editState: .notEditing, catalog: newCatalog, selectedItem: recipe)
        
        case .editRecipe(let recipe):
            let editedRecipe = edit(recipe: recipe, title: title, description: description)
            let newCatalog = state.catalog.replacing(.regular(recipe), by: .regular(editedRecipe))
            return state.copy(editState: .notEditing, catalog: newCatalog, selectedItem: .regular(editedRecipe))
        }
    }^
}


func createRecipe(title: String, description: String) -> CatalogItem {
    .regular(Recipe(
        title: title.isEmpty ? "Empty title" : title,
        description: description,
        dependencies: []))
}

func edit(recipe: Recipe, title: String, description: String) -> Recipe {
    recipe.copy(
        title: title.isEmpty ? recipe.title : title,
        description: description)
}

func searchDependency() -> State<AppState, Void> {
    .modify { state in
        state.copy(panelState: .search)
    }^
}

func cancelSearch() -> State<AppState, Void> {
    .modify { state in
        state.copy(panelState: .catalog)
    }^
}
