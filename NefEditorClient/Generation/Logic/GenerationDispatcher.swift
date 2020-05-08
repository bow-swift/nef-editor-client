import Bow
import BowArch

typealias GenerationDispatcher = StateDispatcher<Any, AppState, GenerationAction>

let generationDispatcher = GenerationDispatcher.pure { input in
    switch input {
    case .authenticationResult(let result):
        return result.fold(authenticationError, authenticationSuccess)
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

func authenticationSuccess(_ info: AuthenticationInfo) -> State<AppState, Void> {
    .modify { state in
        state.copy(
            authenticationState: .authenticated(info),
            generationState: .initial(.authenticated(info), state.selectedItem!)
        )
    }^
}
