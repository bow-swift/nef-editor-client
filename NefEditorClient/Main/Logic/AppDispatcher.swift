import Bow
import BowEffects
import BowOptics
import BowArch

typealias AppDispatcher = StateDispatcher<Any, AppState, AppAction>

let appDispatcher = AppDispatcher.pure { action in
    switch action {
    case .dismissModal:
        return dismissModal()
    
    case .searchAction(let action):
        switch action {
        case .cancelSearch:
            return cancelSearch()
        default:
            return .modify(id)^
        }
        
    case .catalogAction(_), .editAction(_), .catalogDetailAction(_):
        return .modify(id)^
    }
}.combine(catalogDispatcher.widen(
    transformInput: AppAction.prism(for: AppAction.catalogAction)))
.combine(editDispatcher.widen(
    transformInput: AppAction.prism(for: AppAction.editAction)))
.combine(catalogDetailDispatcher.widen(
    transformInput: AppAction.prism(for: AppAction.catalogDetailAction)))

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
