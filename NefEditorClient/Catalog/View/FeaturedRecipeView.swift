import SwiftUI

struct FeaturedRecipeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let featured: FeaturedRecipe
    let isSelected: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(featured.backgroundImage)
                .resizable()
                .mask(RoundedRectangle(cornerRadius: 8))
                .if(colorScheme == .light,
                    then: {
                       $0.shadow(
                        color: self.isSelected ?
                            Color.shadow.opacity(0.6) :
                            Color.shadow.opacity(0.2),
                        radius: self.isSelected ? 6 : 2,
                        x: 1,
                        y: 1)
                })
                .if(colorScheme == .dark && isSelected,
                    then: {
                        $0.overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 2)
                        )
                })
                
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(featured.recipe.title)
                    .titleStyle()
                    .foregroundColor(featured.textColor)
                
                Text(featured.recipe.description)
                    .font(.callout)
                    .lineLimit(2)
                    .foregroundColor(featured.textColor)
                
                Spacer()
                
                TagCloud(tags: featured.tags(textColor: featured.textColor))
            }
            .padding()
        }
    }
}

private extension FeaturedRecipe {
    func tags(textColor: Color) -> [TagViewModel] {
        self.recipe.dependencies.map { dependency in
            TagViewModel(
                text: dependency.repository,
                foregroundColor: textColor,
                backgroundColor: textColor.opacity(0.2))
        }
    }
}

#if DEBUG
struct FeaturedRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedRecipeView(featured: sampleFeaturedRecipe, isSelected: false)
            .aspectRatio(16/9, contentMode: .fit)
            .previewLayout(.fixed(width: 300, height: 300))
            .padding()
    }
}
#endif
