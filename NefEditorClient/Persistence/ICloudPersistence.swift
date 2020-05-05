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
        if let recipes = self.recipes {
            return EnvIO.invoke { _ in
                let decoder = JSONDecoder()
                let data = try Data.init(contentsOf: recipes)
                return try decoder.decode([Recipe].self, from: data)
            }
        } else {
            return EnvIO.pure([])^
        }
    }
    
    func saveUserRecipes<E>(_ recipes: [Recipe]) -> EnvIO<E, Error, Void> {
        if let recipes = self.recipes {
            return EnvIO.invoke { _ in
                let encoder = JSONEncoder()
                let data = try encoder.encode(recipes)
                try data.write(to: recipes)
            }
        } else {
            return EnvIO.pure(())^
        }
    }
}
