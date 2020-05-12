import GitHub
import NefAPI

struct AppDependencies {
    let persistence: Persistence
    let gitHubConfig: GitHub.API.Config
    let nefConfig: NefAPI.API.Config
}
