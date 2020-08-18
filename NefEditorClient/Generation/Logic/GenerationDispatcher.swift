import Foundation
import Bow
import BowEffects
import BowArch
import NefAPI
import NefEditorData
import NefEditorUtils
import NefEditorError

typealias GenerationDispatcher = StateDispatcher<API.Config, AppState, GenerationAction>

let generationDispatcher = GenerationDispatcher.workflow { input in
    switch input {
    case let .authenticationResult(result, item):
        return result.fold(authenticationError,
                           { info in authenticationSuccess(info, item) })
    case .dismissGeneration:
        return [EnvIO.pure(dismissModal())^]
    case let .generate(item: item, token: token):
        return generate(item: item, token: token)
    case .sharePlayground:
        return [EnvIO.pure(showShareDialog())^]
    case .dismissShare:
        return [EnvIO.pure(dismissShareDialog())^]
    }
}

func authenticationError(_ error: Error) -> [EnvIO<API.Config, Error, State<AppState, Void>>] {
    [
        EnvIO.pure(
            .modify { state in
                state.copy(
                    modalState: .generation(.error(.invalidAuthentication)),
                    authenticationState: .unauthenticated)
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
            modalState: .generation(.authenticating)
        )
    }^
}

func generate(item: CatalogItem, token: String) -> [EnvIO<API.Config, Error, State<AppState, Void>>] {
    [
        .pure(setGenerating(item: item))^,
        downloadPlaygroundWorkflow(token: token, item: item)
    ]
}

func setGenerating(item: CatalogItem) -> State<AppState, Void> {
    .modify { state in
        state.copy(
            modalState: .generation(.generating(item))
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
                    modalState: .generation(.initial(.authenticated(token: response.token), item)),
                    authenticationState: .authenticated(token: response.token)
                )
            }^
        }^
}

func signOut(error: GenerationError) -> State<AppState, Void> {
    .modify { state in
        guard error == .invalidBearer else { return state }
        return state.copy(authenticationState: .unauthenticated)
    }^
}

func downloadPlaygroundWorkflow(token: String, item: CatalogItem) -> EnvIO<API.Config, Error, State<AppState, Void>> {
    downloadPlayground(token: token, item: item)
        .flatMap(unzipPlayground)
        .map { url in showPlaygroundFinished(url: url, item: item) }
        .handleError(showPlaygroundError)^
        .handleError(signOut)^
        .mapError(id)
}

func downloadPlayground(token: String, item: CatalogItem) -> EnvIO<API.Config, GenerationError, Data> {
    EnvIO { config in
        let recipe = itemToPlaygroundRecipe(item)
        let encoder = JSONEncoder()
        
        guard let url = URL(string: "\(config.basePath)/playgroundBook"),
              let data = try? encoder.encode(recipe) else {
                return .raiseError(.networkFailure)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.allHTTPHeaderFields = config.appendingHeader(value: "Bearer \(token)", forKey: "Authorization").headers
        
        return config.session
            .downloadDataTaskIO(with: request)
            .mapError { (error: DownloadTaskError<BearerError>) in
                guard case .errorResponse(_) = error else { return .networkFailure }
                return .invalidBearer
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

func unzipPlayground(_ data: Data) -> EnvIO<API.Config, GenerationError, URL> {
    EnvIO { _ in
        let decoder = JSONDecoder()
        if let playground = try? decoder.decode(PlaygroundBookGenerated.self, from: data) {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            return FileManager.default.removeItemIO(at: documentsDirectory.appendingPathComponent("recipe"))
                .handleError { _ in () }
                .followedBy(
                    playground.zip.unzipIO(output: documentsDirectory, name: "recipe")
                        .provide(FileManager.default)
                        .map { url in
                            url.appendingPathComponent(playground.name)
                                .appendingPathExtension("playgroundbook")
                        }
                )^
                .mapError { _ in GenerationError.dataCorrupted }
        } else {
            return IO.raiseError(GenerationError.dataCorrupted)
        }
    }
}

func showPlaygroundFinished(url: URL, item: CatalogItem) -> State<AppState, Void> {
    .modify { state in
        state.copy(modalState: .generation(.finished(item, url, .notSharing)))
    }^
}

func showPlaygroundError(_ error: GenerationError) -> State<AppState, Void> {
    .modify { state in
        state.copy(modalState: .generation(.error(error)))
    }^
}

func showShareDialog() -> State<AppState, Void> {
    .modify { state in
        guard case let .finished(item, url, _) = state.modalState.generationState else {
            return state
        }
        return state.copy(modalState: .generation(.finished(item, url, .sharing)))
    }^
}

func dismissShareDialog() -> State<AppState, Void> {
    .modify { state in
        guard case let .finished(item, url, _) = state.modalState.generationState else {
            return state
        }
        return state.copy(modalState: .generation(.finished(item, url, .notSharing)))
    }^
}
