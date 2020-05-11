import Bow
import BowArch

typealias GenerationDispatcher = StateDispatcher<Any, AppState, GenerationAction>

let generationDispatcher = GenerationDispatcher.pure { input in
    switch input {
    case let .authenticationResult(result, item):
        return result.fold(
            authenticationError,
            { info in authenticationSuccess(info, item) })
    case .dismissGeneration:
        return dismissModal()
    }
}

func authenticationError(_ error: Error) -> State<AppState, Void> {
    .modify { state in
        state.copy(
            authenticationState: .unauthenticated,
            generationState: .error(.invalidAuthentication))
    }^
}

func authenticationSuccess(_ info: AuthenticationInfo, _ item: CatalogItem) -> State<AppState, Void> {
    .modify { state in
        state.copy(
            authenticationState: .authenticated(info),
            generationState: .initial(.authenticated(info), item)
        )
    }^
}
