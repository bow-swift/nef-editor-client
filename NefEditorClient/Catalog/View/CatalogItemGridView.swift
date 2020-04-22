import SwiftUI

struct CatalogItemGridView: View {
    let items: [CatalogItem]
    let columns: Int
    let onItemSelected: (CatalogItem) -> Void
    
    var body: some View {
        GridView(
            rows: self.rows,
            columns: self.columns) { row, column in
                self.viewForItem(row: row, column: column)
                    .aspectRatio(16/9, contentMode: .fit)
                    .animation(nil)
                    .onTapGesture {
                        if let item = self.item(row: row, column: column) {
                            self.onItemSelected(item)
                        }
                    }
        }
    }
    
    private var rows: Int {
        Int(ceil(Double(items.count) / Double(columns)))
    }
    
    private func indexFor(row: Int, column: Int) -> Int {
        row * self.columns + column
    }
    
    private func item(row: Int, column: Int) -> CatalogItem? {
        items[safe: indexFor(row: row, column: column)]
    }
    
    private func viewForItem(row: Int, column: Int) -> some View {
        if let item = item(row: row, column: column) {
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
                CatalogItemGridView(items: sampleFeaturedRecipes, columns: 2) { _ in }
            }
            
            ScrollView {
                CatalogItemGridView(items: sampleRecipes, columns: 3) { _ in }
            }
        }
    }
}
