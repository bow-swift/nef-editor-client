import GitHub

enum RepositoryDetailAction {
    case loadRequirements(Repository)
    case requirementsLoaded([Requirement], for: Repository)
}
