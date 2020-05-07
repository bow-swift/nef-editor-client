import Foundation
import Bow
import BowEffects

class ICloudPersistence: Persistence {
    private var documents: URL? {
        FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
    
    private var recipes: URL? {
        documents?
            .appendingPathComponent("nefRecipes")
            .appendingPathExtension("json")
    }
    
    func loadUserRecipes<E>() -> EnvIO<E, Error, [Recipe]> {
        EnvIO.invoke { _ in
            guard let recipes = self.recipes else { return [] }
            let decoder = JSONDecoder()
            let data = try Data.init(contentsOf: recipes)
            return try decoder.decode([Recipe].self, from: data)
        }
    }
    
    func saveUserRecipes<E>(_ recipes: [Recipe]) -> EnvIO<E, Error, Void> {
        EnvIO.invoke { _ in
            guard let recipesFile = self.recipes else { return }
            let encoder = JSONEncoder()
            let data = try encoder.encode(recipes)
            try data.write(to: recipesFile)
        }
    }
}
