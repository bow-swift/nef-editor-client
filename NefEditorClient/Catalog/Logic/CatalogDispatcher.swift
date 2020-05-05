import Bow
import BowArch
import Foundation

typealias CatalogDispatcher = StateDispatcher<Any, AppState, CatalogAction>

let catalogDispatcher = CatalogDispatcher.pure { action in
    
    switch action {
    case .addRecipe:
        return addRecipe()
        
    case .select(item: let item):
        return select(item: item)
        
    case .duplicate(item: let item):
        return duplicate(item: item)
        
    case .remove(item: let item):
        return remove(item: item)
    }
}

func addRecipe() -> State<AppState, Void> {
    .modify { state in
        state.copy(editState: .newRecipe)
    }^
}

func duplicate(item: CatalogItem) -> State<AppState, Void> {
    .modify { state in
        let recipe = item.recipe.copy(id: UUID(), title: item.recipe.title + " copy")
        let newItem = CatalogItem.regular(recipe)
        let newCatalog = state.catalog.appending(newItem)
        return state.copy(catalog: newCatalog, selectedItem: newItem)
    }^
}

func remove(item: CatalogItem) -> State<AppState, Void> {
    .modify { state in
        if item.isEditable {
            let newCatalog = state.catalog.removing(item)
            let selectedItem = state.selectedItem == item ? nil : state.selectedItem
            return state.copy(catalog: newCatalog, selectedItem: selectedItem)
        } else {
            return state
        }
    }^
}

func select(item: CatalogItem) -> State<AppState, Void> {
    .modify { state in
        if state.selectedItem == item {
            return state.copy(selectedItem: .some(nil))
        } else {
            return state.copy(selectedItem: item)
        }
    }^
}
