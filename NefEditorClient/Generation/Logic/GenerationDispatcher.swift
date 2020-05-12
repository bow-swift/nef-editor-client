import Bow
import BowEffects
import BowArch
import NefAPI

typealias GenerationDispatcher = StateDispatcher<API.Config, AppState, GenerationAction>

let generationDispatcher = GenerationDispatcher.workflow { input in
    switch input {
    case let .authenticationResult(result, item):
        return [EnvIO.invoke { _ in
            result.fold(
                authenticationError,
                { info in authenticationSuccess(info, item) })
        }]
    case .dismissGeneration:
        return [EnvIO.pure(dismissModal())^]
    case let .generate(item: item, info: info):
        return generate(item: item, info: info)
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

func generate(item: CatalogItem, info: AuthenticationInfo) -> [EnvIO<API.Config, Error, State<AppState, Void>>] {
    [
        signIn(info: info).as(.modify(id)^)^
    ]
}

func signIn(info: AuthenticationInfo) -> EnvIO<API.Config, Error, AppleSignInResponse> {
    API.default.signin(body:
        AppleSignInRequest(
            identityToken: info.identityToken,
            authorizationCode: info.authorizationCode))
        .mapError(id)
        .handleErrorWith { error in
            print(error)
            return EnvIO.raiseError(error)^
        }
        .flatTap { x in
            EnvIO { _ in ConsoleIO.print(x) }
        }^
}
