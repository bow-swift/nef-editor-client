import Bow
import BowEffects
import BowArch

typealias AppDispatcher = StateDispatcher<Any, AppState, AppAction>

let appDispatcher = AppDispatcher { action, handler in
    switch action {
        
    case .addRecipe:
        return handler.send(action: addRecipe())
    
    case .edit(item: let item):
        return handler.send(action: edit(item: item))
    
    case .dismissEdition:
        return handler.send(action: dismissEdition())
        
    case .saveRecipe(title: let title, description: let description):
        return handler.send(action: saveRecipe(title: title, description: description))
        
    case .searchDependency:
        return handler.send(action: searchDependency())
    
    case .select(item: let item):
        return handler.send(action: select(item: item))
    }
}

func addRecipe() -> State<AppState, Void> {
    .modify { state in
        state.copy(editState: .newRecipe)
    }^
}

func edit(item: CatalogItem) -> State<AppState, Void> {
    if case let .regular(recipe) = item {
        return .modify { state in
            state.copy(editState: .editRecipe(recipe))
        }^
    } else {
        return .modify(id)^
    }
}

func dismissEdition() -> State<AppState, Void> {
    .modify { state in
        state.copy(editState: .notEditing)
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
        case .editRecipe(_):
            return state
        }
    }^
}

func createRecipe(title: String, description: String) -> CatalogItem {
    .regular(Recipe(
        title: title.isEmpty ? "Empty title" : title,
        description: description,
        dependencies: []))
}

func searchDependency() -> State<AppState, Void> {
    .modify { state in
        state.copy(panelState: .search)
    }^
}

func select(item: CatalogItem) -> State<AppState, Void> {
    .modify { state in
        state.copy(selectedItem: item)
    }^
}
