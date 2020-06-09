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
        guard let editState = state.modalState.editState else { return state }
        
        switch editState {
            case .newRecipe:
                let recipe = createRecipe(title: title, description: description)
                return state.addRecipe(recipe)
            
            case .editRecipe(let recipe):
                let editedRecipe = edit(recipe: recipe, title: title, description: description)
                let newCatalog = state.catalog.replacing(.regular(recipe), by: .regular(editedRecipe))
                return state.copy(modalState: .noModal, catalog: newCatalog, selectedItem: .regular(editedRecipe))
            }
    }^
}

func createRecipe(title: String, description: String) -> Recipe {
    .init(title: title.isEmpty ? "Empty title" : title,
          description: description,
          dependencies: [])
}

func edit(recipe: Recipe, title: String, description: String) -> Recipe {
    recipe.copy(title: title.isEmpty ? recipe.title : title,
                description: description)
}

extension AppState {
    func addRecipe(_ recipe: Recipe) -> Self {
        let catalogItem: CatalogItem = .regular(recipe)
        let newCatalog = catalog.appending(catalogItem)
        return self.copy(modalState: .noModal, catalog: newCatalog, selectedItem: catalogItem)
    }
}
