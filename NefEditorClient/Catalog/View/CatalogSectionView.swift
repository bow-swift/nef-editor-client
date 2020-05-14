import SwiftUI

struct CatalogSectionView: View {
    let section: CatalogSection
    let selectedItem: CatalogItem?
    let columns: Int
    let handle: (CatalogAction) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            sectionTitle(for: self.section)
                .padding(.top, 16)
                .padding(.horizontal, 16)

            if section.items.isEmpty {
                Text("There are no recipes yet.")
                    .activityStyle()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(24)
            } else {
                CatalogItemGridView(
                    items: section.items,
                    selectedItem: self.selectedItem,
                    columns: self.columns,
                    handle: self.handle)
                .padding(.horizontal, 16)
            }
        }
    }
    
    func sectionTitle(for section: CatalogSection) -> some View {
        guard let action = section.action else {
            return SectionTitle(title: section.title)
        }
        
        return SectionTitle(title: section.title,
                            action: .init(icon: Image(systemName: action.icon),
                                          handle: self.handle(action.action)))
    }
}

#if DEBUG
struct CatalogSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            CatalogSectionView(section: sampleRecipesSection, selectedItem: nil, columns: 2) { _ in }
        }
    }
}
#endif
