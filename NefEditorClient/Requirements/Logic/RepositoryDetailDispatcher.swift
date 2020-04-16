import GitHub
import Bow
import BowEffects
import BowArch

typealias RepositoryDetailDispatcher = StateDispatcher<API.Config, RepositoryDetailState, RepositoryDetailAction>
typealias RepositoryDetailHandler = StateHandler<API.Config, RepositoryDetailState, RepositoryDetailAction>

let repositoryDetailDispatcher = RepositoryDetailDispatcher { action, handler in
    switch action {
    case .loadRequirements(let repository):
        return loadRequirements(repository: repository, handler: handler)
            .handleErrorWith { _ in onError(repository: repository, handler: handler) }^
    case .requirementsLoaded(let requirements, for: let repository):
        return handler.send(action:
            .set(requirementsLoaded(requirements, for: repository))
        )
    }
}

func loadRequirements(
    repository: Repository,
    handler: RepositoryDetailHandler
) -> EnvIO<API.Config, Error, [RepositoryDetailAction]> {
    let tags = EnvIO<API.Config, Error, Tags>.var()
    let branches = EnvIO<API.Config, Error, Branches>.var()
    let requirements = EnvIO<API.Config, Error, [Requirement]>.var()
    
    return binding(
        (tags, branches) <- parallel(loadTags(repository: repository),
                                     loadBranches(repository: repository)),
        requirements <- EnvIO.pure(merge(tags: tags.get, branches: branches.get)),
        yield: [.requirementsLoaded(requirements.get, for: repository)])^
}

func onError(
    repository: Repository,
    handler: RepositoryDetailHandler
) -> EnvIO<API.Config, Error, [RepositoryDetailAction]> {
    handler.send(action:
        .set(.error(repository,
                    message: "An error ocurred trying to fetch tags and branches for the repository '\(repository.fullName)'"))
    )
}

func loadTags(
    repository: Repository
) -> EnvIO<API.Config, Error, Tags> {
    API.repository.getVersions(fullName: repository.fullName)
        .mapError(id)
}

func loadBranches(
    repository: Repository
) -> EnvIO<API.Config, Error, Branches> {
    API.repository.getBranches(fullName: repository.fullName)
        .mapError(id)
}

func merge(tags: Tags, branches: Branches) -> [Requirement] {
    tags.map(Requirement.version) +
    branches.map(Requirement.branch)
}

func requirementsLoaded(
    _ requirements: [Requirement],
    for repository: Repository
) -> RepositoryDetailState {
    if requirements.isEmpty {
        return .empty(repository)
    } else {
        return .loaded(repository, requirements: requirements)
    }
}
