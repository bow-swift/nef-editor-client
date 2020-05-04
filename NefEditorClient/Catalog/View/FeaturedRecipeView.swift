import SwiftUI

struct FeaturedRecipeView: View {
    let featured: FeaturedRecipe
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(featured.backgroundImage)
                .resizable()
                .mask(RoundedRectangle(cornerRadius: 8))
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(featured.recipe.title)
                    .titleStyle()
                    .foregroundColor(featured.textColor)
                
                Text(featured.recipe.description)
                    .font(.callout)
                    .lineLimit(2)
                    .foregroundColor(featured.textColor)
                
                Spacer()
                
                TagCloud(tags: featured.tags)
            }
            .padding()
        }
    }
}

private extension FeaturedRecipe {
    var tags: [TagViewModel] {
        self.recipe.dependencies.map { dependency in
            TagViewModel(
                text: dependency.repository,
                foregroundColor: .white,
                backgroundColor: Color.white.opacity(0.2))
        }
    }
}

#if DEBUG
struct FeaturedRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedRecipeView(featured: sampleFeaturedRecipe)
            .aspectRatio(16/9, contentMode: .fit)
            .previewLayout(.fixed(width: 300, height: 300))
            .padding()
    }
}
#endif
