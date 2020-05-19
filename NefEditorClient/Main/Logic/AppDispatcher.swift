import Bow
import BowEffects
import BowOptics
import BowArch

typealias AppDispatcher = StateDispatcher<AppDependencies, AppState, AppAction>

let appDispatcher: AppDispatcher = mainDispatcher
    .widen(transformEnvironment: \.persistence)
    
    .combine(catalogDispatcher.widen(
        transformEnvironment: id,
        transformInput: AppAction.prism(for: AppAction.catalogAction)))
    
    .combine(editDispatcher.widen(
        transformEnvironment: id,
        transformInput: AppAction.prism(for: AppAction.editAction)))
    
    .combine(catalogDetailDispatcher.widen(
        transformEnvironment: id,
        transformInput: AppAction.prism(for: AppAction.catalogDetailAction)))
    
    .combine(addDependencyDispatcher.widen(
        transformEnvironment: id,
        transformInput: AppAction.prism(for: AppAction.searchAction) +
            SearchAction.prism(for: SearchAction.repositoryDetailAction)))
    
    .combine(searchDispatcher.widen(
        transformEnvironment: \.gitHubConfig,
        transformState: AppState.searchStateLens,
        transformInput: AppAction.prism(for: AppAction.searchAction)))
    
    .combine(generationDispatcher.widen(
        transformEnvironment: \.nefConfig,
        transformInput: AppAction.prism(for: AppAction.generationAction)))
    
    .combine(creditsDispatcher.widen(
        transformEnvironment: id,
        transformInput: AppAction.prism(for: AppAction.creditsAction)))

    .combine(faqDispatcher.widen(
        transformEnvironment: id,
        transformInput: AppAction.prism(for: AppAction.faqAction)))
