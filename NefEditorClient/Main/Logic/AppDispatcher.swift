import Bow
import BowEffects
import BowOptics
import BowArch

typealias AppDispatcher = StateDispatcher<Any, AppState, AppAction>

let appDispatcher = AppDispatcher.pure { action in
    switch action {
    case .catalogAction(_), .editAction(_):
        return .modify(id)^
        
    case .edit(item: let item):
        return edit(item: item)
    
    case .dismissModal:
        return dismissModal()
        
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
.combine(editDispatcher.widen(
    transformEnvironment: id,
    transformState: Lens.identity,
    transformInput: AppAction.prism(for: AppAction.editAction)))

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
