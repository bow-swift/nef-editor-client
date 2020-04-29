import GitHub
import Bow
import BowEffects
import BowArch

typealias RepositoryDetailDispatcher = StateDispatcher<API.Config, SearchModalState, RepositoryDetailAction>

let repositoryDetailDispatcher = RepositoryDetailDispatcher.effectful { action in
    switch action {
    case .loadRequirements(let repository):
        return loadRequirements(repository: repository).handleError { _ in
            onError(repository: repository)
        }^
    }
}

func loadRequirements(
    repository: Repository
) -> EnvIO<API.Config, Error, StateOf<SearchModalState, Void>> {
    
    let tags = EnvIO<API.Config, Error, Tags>.var()
    let branches = EnvIO<API.Config, Error, Branches>.var()
    let requirements = EnvIO<API.Config, Error, [Requirement]>.var()

    return binding(
        (tags, branches) <- parallel(loadTags(repository: repository),
                                     loadBranches(repository: repository)),
        requirements <- EnvIO.pure(merge(tags: tags.get, branches: branches.get)),
        yield: requirementsLoaded(requirements.get, for: repository))^
}

func onError(
    repository: Repository
) -> StateOf<SearchModalState, Void> {
    .set(.repositoryDetail(
        .error(repository,
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
) -> StateOf<SearchModalState, Void> {
    if requirements.isEmpty {
        return .set(.repositoryDetail(.empty(repository)))
    } else {
        return .set(.repositoryDetail(.loaded(repository, requirements: requirements)))
    }
}
