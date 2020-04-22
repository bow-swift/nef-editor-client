import Bow

enum CatalogItem: Equatable {
    case featured(FeaturedRecipe)
    case regular(Recipe)
    
    private func fold<A>(
        _ ifFeatured: (FeaturedRecipe) -> A,
        _ ifRegular: (Recipe) -> A
    ) -> A {
        switch self {
        case .featured(let featured): return ifFeatured(featured)
        case .regular(let recipe): return ifRegular(recipe)
        }
    }
    
    private func fold<A>(
        _ ifFeatured: KeyPath<FeaturedRecipe, A>,
        _ ifRegular: KeyPath<Recipe, A>
    ) -> A {
        self.fold({ $0[keyPath: ifFeatured] },
                  { $0[keyPath: ifRegular] })
    }
    
    var title: String {
        self.fold(\.recipe.title,
                  \.title)
    }
    
    var description: String {
        self.fold(\.recipe.description,
                  \.description)
    }
    
    var dependencies: [Dependency] {
        self.fold(\.recipe.dependencies,
                  \.dependencies)
    }
    
    var isEditable: Bool {
        self.fold(constant(false), constant(true))
    }
    
    var recipe: Recipe {
        self.fold(\.recipe, \.self)
    }
}
