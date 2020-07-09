import Bow
import BowEffects
import BowArch

typealias DeepLinkDispatcher = StateDispatcher<Persistence, AppState, DeepLinkAction>

let deepLinkDispatcher = DeepLinkDispatcher.workflow { action in
    switch action {
    case .generateRecipe(let recipe):
        return initialLoad(recipe)
    case .regularInitialization:
        return [initialLoad()]
    }
}

func addNewRecipe(_ recipe: Recipe) -> State<AppState, Void> {
    .modify { state in
        state.addRecipe(recipe)
    }^
}

func clearDeepLink() -> State<AppState, Void> {
    .modify { state in
        state.copy(deepLinkState: DeepLinkState.none)
    }^
}

func generatePlayground(newRecipe recipe: Recipe) -> EnvIO<Persistence, Error, State<AppState, Void>> {
    EnvIO.pure(
        clearDeepLink()
            .followedBy(addNewRecipe(recipe))
            .followedBy(generatePlayground(for: .regular(recipe)))^
    )^
}

func initialLoad(_ recipe: Recipe) -> [EnvIO<Persistence, Error, State<AppState, Void>>] {
    [
        initialLoad(),
        generatePlayground(newRecipe: recipe),
    ]
}
