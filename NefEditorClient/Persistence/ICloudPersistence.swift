import Foundation
import Bow
import BowEffects

class ICloudPersistence: Persistence {
    private var documents: URL? {
        FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
    
    private var preferencesStore: NSUbiquitousKeyValueStore { .default }
    
    private var recipes: URL? {
        documents?
            .appendingPathComponent("nefRecipes")
            .appendingPathExtension("json")
    }
    
    var isPersistenceAvailable: Bool {
        self.recipes != nil
    }
    
    // MARK: recipes
    func loadUserRecipes<D>() -> EnvIO<D, Error, [Recipe]> {
        EnvIO.invoke { _ in
            guard let recipes = self.recipes else { return [] }
            let decoder = JSONDecoder()
            let data = try Data.init(contentsOf: recipes)
            return try decoder.decode([Recipe].self, from: data)
        }
    }
    
    func saveUserRecipes<D>(_ recipes: [Recipe]) -> EnvIO<D, Error, Void> {
        EnvIO.invoke { _ in
            guard let recipesFile = self.recipes else { return }
            let encoder = JSONEncoder()
            let data = try encoder.encode(recipes)
            try data.write(to: recipesFile)
        }
    }
    
    // MARK: user preferences
    func loadUserPreferences<D>() -> EnvIO<D, Error, UserPreferences> {
        EnvIO.invoke { _ in
            guard let data = self.preferencesStore.data(forKey: StoreKey.userPreferences),
                  let preferences = try? JSONDecoder().decode(UserPreferences.self, from: data) else {
                    throw UserPreferencesError.invalidData
            }
            
            return preferences
        }
    }
    
    func updateUserPreferences<D>(bundleVersion: String) -> EnvIO<D, Error, Void> {
        EnvIO.invoke { _ in
            let userPreferences = UserPreferences(whatsNewBundle: bundleVersion)
            let data = try JSONEncoder().encode(userPreferences)
            self.preferencesStore.set(data, forKey: StoreKey.userPreferences)
        }
    }
    
    // MARK: - Constants
    private enum StoreKey {
        static let userPreferences = "user-preferences"
    }
}
