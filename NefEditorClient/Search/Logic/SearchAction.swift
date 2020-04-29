import GitHub
import BowOptics

enum SearchAction: AutoPrism {
    case search(query: String)
    case showDetails(Repository)
    case dismissDetails
    case cancelSearch
    case repositoryDetailAction(RepositoryDetailAction)
}
