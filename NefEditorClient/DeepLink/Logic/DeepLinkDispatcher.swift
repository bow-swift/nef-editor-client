import Bow
import BowEffects
import BowArch

typealias DeepLinkDispatcher = StateDispatcher<Persistence, AppState, DeepLinkAction>

let deepLinkDispatcher = DeepLinkDispatcher.effectful { action in
    switch action {
    case .generateRecipe(let recipe):
        return initialLoad(recipe)
    case .regularInitialization:
        return initialLoad()
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

func initialLoad(_ recipe: Recipe) -> EnvIO<Persistence, Error, State<AppState, Void>> {
    let deepLink = addNewRecipe(recipe)
        .followedBy(generatePlayground(for: .regular(recipe)))
        .followedBy(clearDeepLink())^
    
    return initialLoad().followedBy(EnvIO.pure(deepLink)^)^
}
