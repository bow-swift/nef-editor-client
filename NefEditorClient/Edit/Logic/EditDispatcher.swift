import Bow
import BowArch

typealias EditDispatcher = StateDispatcher<Any, AppState, EditAction>

let editDispatcher = EditDispatcher.pure { input in
    switch input {
    case let .saveRecipe(title: title, description: description):
        return saveRecipe(title: title, description: description)
        
    case .dismissEdition:
        return dismissModal()
    }
}

func saveRecipe(title: String, description: String) -> State<AppState, Void> {
    .modify { state in
        if let editState = state.modalState.editState {
            switch editState {
            case .newRecipe:
                let recipe = createRecipe(title: title, description: description)
                let newCatalog = state.catalog.appending(recipe)
                return state.copy(modalState: .noModal, catalog: newCatalog, selectedItem: recipe)
            
            case .editRecipe(let recipe):
                let editedRecipe = edit(recipe: recipe, title: title, description: description)
                let newCatalog = state.catalog.replacing(.regular(recipe), by: .regular(editedRecipe))
                return state.copy(modalState: .noModal, catalog: newCatalog, selectedItem: .regular(editedRecipe))
            }
        } else {
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

func edit(recipe: Recipe, title: String, description: String) -> Recipe {
    recipe.copy(
        title: title.isEmpty ? recipe.title : title,
        description: description)
}
