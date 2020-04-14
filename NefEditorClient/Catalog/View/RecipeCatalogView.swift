import SwiftUI

struct RecipeCatalogView: View {
    let recipes: [Recipe]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Featured recipes")
                        .largeTitleStyle()
                    
                    RecipeGridView(
                        recipes: self.recipes,
                        columns: self.columns(for: geometry.size))
                }.padding()
            }
        }
    }
    
    private func columns(for size: CGSize) -> Int {
        let minimumCardWidth: CGFloat = 350
        return Int(floor(size.width / minimumCardWidth))
    }
}

struct RecipeCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCatalogView(recipes: sampleRecipes)
            .previewLayout(.fixed(width: 910, height: 1024))
    }
}
