import BowEffects

protocol Persistence {
    func loadUserRecipes<E>() -> EnvIO<E, Error, [Recipe]>
    func saveUserRecipes<E>(_ recipes: [Recipe]) -> EnvIO<E, Error, Void>
}
