import SwiftUI

struct CatalogSectionView: View {
    let section: CatalogSection
    let selectedItem: CatalogItem?
    let columns: Int
    let handle: (CatalogAction) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(section.title)
                    .largeTitleStyle()
                
                self.actionView(for: self.section)
                
                Spacer()
            }
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
    
    func actionView(for section: CatalogSection) -> some View {
        if let action = section.action {
            return AnyView(Button(action: { self.handle(action.action) }) {
                Image(systemName: action.icon)
            }.buttonStyle(ActionButtonStyle()))
        } else {
            return AnyView(EmptyView())
        }
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
