import Foundation
import Bow
import BowEffects
import BowArch
import NefAPI
import NefEditorData

typealias GenerationDispatcher = StateDispatcher<API.Config, AppState, GenerationAction>

let generationDispatcher = GenerationDispatcher.workflow { input in
    switch input {
    case let .authenticationResult(result, item):
        return result.fold(
            authenticationError,
            { info in authenticationSuccess(info, item) })
    case .dismissGeneration:
        return [EnvIO.pure(dismissModal())^]
    case let .generate(item: item, token: token):
        return generate(item: item, token: token)
    }
}

func authenticationError(_ error: Error) -> [EnvIO<API.Config, Error, State<AppState, Void>>] {
    [
        EnvIO.pure(
            .modify { state in
                state.copy(
                    authenticationState: .unauthenticated,
                    generationState: .error(.invalidAuthentication))
            }^
        )^
    ]
}

func authenticationSuccess(_ info: AuthenticationInfo, _ item: CatalogItem) -> [EnvIO<API.Config, Error, State<AppState, Void>>] {
    [
        EnvIO.pure(setAuthenticating())^,
        signIn(info: info, item: item)
    ]
}

func setAuthenticating() -> State<AppState, Void> {
    .modify { state in
        state.copy(
            generationState: .authenticating
        )
    }^
}

func generate(item: CatalogItem, token: String) -> [EnvIO<API.Config, Error, State<AppState, Void>>] {
    [
        EnvIO.pure(setGenerating(item: item))^,
        downloadPlayground(token: token, item: item)
            .as(
                .modify { state in
                    state.copy(generationState: .finished(item))
                }^
            ).handleError { _ in
                .modify { state in
                    state.copy(generationState: .error(.networkFailure))
                }^
            }^
    ]
}

func setGenerating(item: CatalogItem) -> State<AppState, Void> {
    .modify { state in
        state.copy(
            generationState: .generating(item)
        )
    }^
}

func signIn(info: AuthenticationInfo, item: CatalogItem) -> EnvIO<API.Config, Error, State<AppState, Void>> {
    API.default.signin(body:
        AppleSignInRequest(
            identityToken: info.identityToken,
            authorizationCode: info.authorizationCode))
        .mapError(id)
        .map { response in
            .modify { state in
                state.copy(
                    authenticationState: .authenticated(token: response.token),
                    generationState: .initial(.authenticated(token: response.token), item)
                )
            }^
        }^
}

func downloadPlayground(token: String, item: CatalogItem) -> EnvIO<API.Config, Error, URL> {
    
    EnvIO { config in
        let recipe = itemToPlaygroundRecipe(item)
        let encoder = JSONEncoder()
        
        if let url = URL(string: "\(config.basePath)/playgroundBook"),
            let data = try? encoder.encode(recipe) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data
            request.allHTTPHeaderFields = config
                .appendingHeader(
                    value: "Bearer \(token)",
                    forKey: "Authorization"
                ).headers
            
            return config
                .session.downloadTaskIO(with: request)
                .map { result in result.url }
        } else {
            fatalError()
        }
    }
}

func itemToPlaygroundRecipe(_ item: CatalogItem) -> PlaygroundRecipe {
    PlaygroundRecipe(
        name: item.title,
        dependencies: item.dependencies.map(dependencyToPlaygroundDependency))
}

func dependencyToPlaygroundDependency(_ dependency: Dependency) -> PlaygroundDependency {
    PlaygroundDependency(
        name: dependency.repository,
        url: dependency.url,
        requirement: requirementToPlaygroundRequirement(dependency.requirement))
}

func requirementToPlaygroundRequirement(_ requirement: Requirement) -> PlaygroundDependency.Requirement {
    switch requirement {
    case .branch(let branch):
        return .branch(branch.name)
    case .version(let tag):
        return .version(tag.name)
    }
}
