import Bow
import BowArch

typealias CatalogDetailDispatcher = StateDispatcher<Any, AppState, CatalogDetailAction>

let catalogDetailDispatcher = CatalogDetailDispatcher.pure { action in
    switch action {
    case .edit(item: let item):
        return edit(item: item)
    case .searchDependency:
        return searchDependency()
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
