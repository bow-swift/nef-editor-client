import Bow
import BowArch

typealias CatalogDetailDispatcher = StateDispatcher<Any, AppState, CatalogDetailAction>

let catalogDetailDispatcher = CatalogDetailDispatcher.pure { action in
    switch action {
    case .edit(item: let item):
        return edit(item: item)
    case .searchDependency:
        return searchDependency()
    case .remove(let dependency):
        return remove(dependency: dependency)
    case .dismissDetail:
        return clearSelection()
    }
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

func searchDependency() -> State<AppState, Void> {
    .modify { state in
        state.copy(panelState: .search)
    }^
}

func remove(dependency: Dependency) -> State<AppState, Void> {
    .modify { state in
        if let selected = state.selectedItem {
            let newSelected = selected.removing(dependency: dependency)
            let newCatalog = state.catalog.replacing(selected, by: newSelected)
            return state.copy(catalog: newCatalog, selectedItem: newSelected)
        } else {
            return state
        }
    }^
}

func clearSelection() -> State<AppState, Void> {
    .modify { state in
        if state.panelState == .search {
            return state.copy(panelState: .catalog)
        } else {
            return state.copy(selectedItem: .some(nil))
        }
        
    }^
}
