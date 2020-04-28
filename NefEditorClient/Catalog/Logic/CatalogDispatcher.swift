import Bow
import BowArch

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
        let recipe = item.recipe.copy(title: item.recipe.title + " copy")
        let newItem = CatalogItem.regular(recipe)
        let newCatalog = state.catalog.appending(newItem)
        return state.copy(catalog: newCatalog, selectedItem: newItem)
    }^
}

func remove(item: CatalogItem) -> State<AppState, Void> {
    .modify { state in
        if item.isEditable {
            let newCatalog = state.catalog.removing(item)
            let selectedItem = state.selectedItem == item ? Catalog.initialSelection : state.selectedItem
            return state.copy(catalog: newCatalog, selectedItem: selectedItem)
        } else {
            return state
        }
    }^
}

func select(item: CatalogItem) -> State<AppState, Void> {
    .modify { state in
        state.copy(selectedItem: item)
    }^
}
