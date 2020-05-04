import SwiftUI

struct RecipeCatalogView: View {
    let catalog: Catalog
    let selectedItem: CatalogItem?
    let handle: (CatalogAction) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(self.catalog.sections, id: \.title) { section in
                        CatalogSectionView(
                            section: section,
                            columns: self.columns(for: geometry.size),
                            handle: self.handle)
                    }
                }.padding()
            }.transition(.identity)
            .animation(nil)
        }
    }
    
    private func columns(for size: CGSize) -> Int {
        let minimumCardWidth: CGFloat = 350
        return Int(floor(size.width / minimumCardWidth))
    }
}

#if DEBUG
struct RecipeCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCatalogView(catalog: sampleCatalog, selectedItem: nil) { _ in }
            .previewLayout(.fixed(width: 910, height: 1024))
    }
}
#endif
