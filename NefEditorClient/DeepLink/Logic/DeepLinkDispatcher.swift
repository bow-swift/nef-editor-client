import UIKit
import Bow
import BowEffects
import BowArch

typealias DeepLinkDispatcher = StateDispatcher<Any, AppState, DeepLinkAction>

let deepLinkDispatcher = DeepLinkDispatcher.workflow { action in
    switch action {
    case .generateRecipe(let recipe):
        return generateNewRecipe(recipe)
    }
}

func addNewRecipe(_ recipe: Recipe) -> State<AppState, Void> {
    .modify { (state: AppState) in
        let catalogItem: CatalogItem = .regular(recipe)
        let catalog = state.catalog.appending(catalogItem)
        return state.copy(catalog: catalog, selectedItem: catalogItem)
    }^
}

func emptyDeepLink() -> State<AppState, Void> {
    .modify { state in
        state.copy(deepLinkState: DeepLinkState.none)
    }^
}

func generateNewRecipe(_ recipe: Recipe) -> [EnvIO<Any, Error, State<AppState, Void>>] {
    [
        EnvIO.pure(addNewRecipe(recipe))^,
        EnvIO.pure(generatePlayground(for: .regular(recipe)))^,
        EnvIO.pure(emptyDeepLink())^,
    ]
}
