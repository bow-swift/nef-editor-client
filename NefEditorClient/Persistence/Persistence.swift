import BowEffects

protocol Persistence {
    var isPersistenceAvailable: Bool { get }
    func loadUserRecipes<D>() -> EnvIO<D, Error, [Recipe]>
    func saveUserRecipes<D>(_ recipes: [Recipe]) -> EnvIO<D, Error, Void>
    func loadUserPreferences<D>() -> EnvIO<D, Error, UserPreferences>
    func updateUserPreferences<D>(bundleVersion: String) -> EnvIO<D, Error, Void>
}
