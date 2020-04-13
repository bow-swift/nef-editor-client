import SwiftUI

struct CatalogItemGridView: View {
    let recipes: [CatalogItem]
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
        if let item = recipes[safe: indexFor(row: row, column: column)] {
            switch item {
            case .regular(let recipe):
                return AnyView(RegularRecipeView(recipe: recipe))
            case .featured(let featured):
                return AnyView(FeaturedRecipeView(featured: featured))
            }
        } else {
            return AnyView(Color.clear)
        }
    }
}

struct RecipeGridView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScrollView {
                CatalogItemGridView(recipes: sampleFeaturedRecipes, columns: 2)
            }
            
            ScrollView {
                CatalogItemGridView(recipes: sampleRecipes, columns: 3)
            }
        }
    }
}
