import GitHub

enum RepositoryDetailAction {
    case loadRequirements(Repository)
    case dependencySelected(Requirement, from: Repository)
    case dismissDetails
}
