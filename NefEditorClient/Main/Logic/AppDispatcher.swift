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
