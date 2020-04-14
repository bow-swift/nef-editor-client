import SwiftUI

struct RecipeGridView: View {
    let recipes: [Recipe]
    let columns: Int
    
    var body: some View {
        GridView(
            rows: self.rows,
            columns: self.columns) { row, column in
                self.viewForItem(row: row, column: column)
                    .aspectRatio(16/9, contentMode: .fit)
                    .animation(nil)
        }
    }
    
    private var rows: Int {
        Int(ceil(Double(recipes.count) / Double(columns)))
    }
    
    private func indexFor(row: Int, column: Int) -> Int {
        row * self.columns + column
    }
    
    private func viewForItem(row: Int, column: Int) -> some View {
        if let recipe = recipes[safe: indexFor(row: row, column: column)] {
            return AnyView(RegularRecipeView(recipe: recipe))
        } else {
            return AnyView(Color.clear)
        }
    }
}

struct RecipeGridView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScrollView {
                RecipeGridView(recipes: sampleRecipes, columns: 2)
            }
            
            ScrollView {
                RecipeGridView(recipes: sampleRecipes, columns: 3)
            }
        }
    }
}
