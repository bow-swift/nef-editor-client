import Foundation
import Bow
import BowEffects
import BowArch
import NefAPI
import NefEditorData
import NefEditorUtils
import UIKit

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
    case .openPlayground(url: let url):
        return [openPlayground(url: url)]
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
            .flatMap(unzipPlayground)
            .map { url in
                .modify { state in
                    state.copy(generationState: .finished(item, url))
                }^
            }.handleError { error in
                .modify { state in
                    state.copy(generationState: .error(error))
                }^
            }^
            .mapError(id)
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

func downloadPlayground(token: String, item: CatalogItem) -> EnvIO<API.Config, GenerationError, Data> {
    
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
            
            return config.session.downloadDataTaskIO(with: request)
                .mapError { _ in GenerationError.networkFailure }
        } else {
            return IO.raiseError(GenerationError.networkFailure)
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

enum AppStore {
    static let swiftPlaygroundsURL = URL(string: "itms-apps://itunes.apple.com/app/id908519492")!
}

func openPlayground(url: URL) -> EnvIO<API.Config, Error, State<AppState, Void>> {
    EnvIO.later(.main) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(AppStore.swiftPlaygroundsURL)
        }
    }.as(.modify(id)^)^
}

extension URLSession {
    func downloadDataTaskIO(with request: URLRequest) -> IO<Error, Data> {
        IO.async { callback in
            self.downloadTask(with: request) { url, response, error in
                if let url = url, let data = try? Data(contentsOf: url) {
                    callback(.right(data))
                } else if let error = error {
                    callback(.left(error))
                } else {
                    callback(.left(GenerationError.dataCorrupted))
                }
            }.resume()
        }^
    }
}
