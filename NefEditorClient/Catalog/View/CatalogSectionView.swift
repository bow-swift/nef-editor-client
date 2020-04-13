import SwiftUI

struct CatalogSectionView: View {
    let section: CatalogSection
    let columns: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(section.title)
                .largeTitleStyle()
                .padding(.top, 16)
            
            RecipeGridView(recipes: section.items, columns: self.columns)
        }
    }
}

struct CatalogSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            CatalogSectionView(section: sampleRecipesSection, columns: 2)
        }
    }
}
