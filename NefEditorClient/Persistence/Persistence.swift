import BowEffects

protocol Persistence {
    var isPersistenceAvailable: Bool { get }
    func loadUserRecipes<E>() -> EnvIO<E, Error, [Recipe]>
    func saveUserRecipes<E>(_ recipes: [Recipe]) -> EnvIO<E, Error, Void>
}
