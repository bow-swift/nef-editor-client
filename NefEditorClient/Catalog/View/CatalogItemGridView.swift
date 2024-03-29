import SwiftUI

struct CatalogItemGridView: View {
    let items: [CatalogItem]
    let selectedItem: CatalogItem?
    let columns: Int
    let handle: (CatalogAction) -> Void
    
    var body: some View {
        GridView(
            rows: self.rows,
            columns: self.columns) { row, column in
                self.viewForItem(row: row, column: column)
                    .aspectRatio(16/9, contentMode: .fit)
                    .onTapGesture {
                        if let item = self.item(row: row, column: column) {
                            self.handle(.select(item: item))
                        }
                    }
                    .safeHoverEffect()
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
                return AnyView(
                    RegularRecipeView(recipe: recipe, isSelected: item == selectedItem)
                        .contextMenu {
                            self.duplicateButton(for: item)
                            self.removeButton(for: item)
                        })
            case .featured(let featured):
                return AnyView(
                    FeaturedRecipeView(featured: featured, isSelected: item == selectedItem)
                        .contextMenu {
                            self.duplicateButton(for: item)
                        })
            }
        } else {
            return AnyView(Color.clear)
        }
    }
    
    private func duplicateButton(for item: CatalogItem) -> some View {
        Button(action: { self.handle(.duplicate(item: item)) }) {
            Text("Duplicate recipe")
            Image.duplicate
        }
    }
    
    private func removeButton(for item: CatalogItem) -> some View {
        Button(action: { self.handle(.remove(item: item)) }) {
            Text("Remove recipe")
            Image.trash
        }
    }
}

#if DEBUG
struct RecipeGridView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScrollView {
                CatalogItemGridView(items: sampleFeaturedRecipes, selectedItem: nil, columns: 2) { _ in }
            }
            
            ScrollView {
                CatalogItemGridView(items: sampleRecipes, selectedItem: nil, columns: 3) { _ in }
            }
        }
    }
}
#endif
