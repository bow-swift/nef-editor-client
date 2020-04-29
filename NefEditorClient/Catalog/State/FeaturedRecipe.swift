import SwiftUI

struct FeaturedRecipe: Equatable, Identifiable {
    let recipe: Recipe
    let backgroundImage: String
    let textColor: Color
    
    var id: UUID {
        recipe.id
    }
}
