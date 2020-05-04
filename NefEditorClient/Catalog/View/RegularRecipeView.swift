import SwiftUI

struct RegularRecipeView: View {
    let recipe: Recipe
    let isSelected: Bool
    
    var body: some View {
        CardView(isSelected: isSelected) {
            VStack(alignment: .leading, spacing: 8) {
                Text(self.recipe.title)
                    .titleStyle()
                Text(self.recipe.description)
                    .activityStyle()
                
                Spacer()
                
                TagCloud(
                    tags: self.recipe.tags,
                    layout: TagCloud.Layouts.multiline(spacing: 4, lines: 2))
            }.padding()
        }
    }
}

private extension Recipe {
    var tags: [TagViewModel] {
        self.dependencies.map { dependency in
            TagViewModel(text: dependency.repository)
        }
    }
}

#if DEBUG
struct RegularRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RegularRecipeView(recipe: sampleRecipe, isSelected: false)
            .aspectRatio(16/9, contentMode: .fit)
            .frame(maxWidth: 350, maxHeight: 300)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
