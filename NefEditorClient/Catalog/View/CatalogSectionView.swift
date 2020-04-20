import SwiftUI

struct CatalogSectionView: View {
    let section: CatalogSection
    let columns: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(section.title)
                    .largeTitleStyle()
                
                Spacer()
                
                self.actionView(for: self.section)
            }.padding(.top, 16)
            
            CatalogItemGridView(items: section.items, columns: self.columns)
        }
    }
    
    func actionView(for section: CatalogSection) -> some View {
        if let action = section.action {
            return AnyView(Button(action: {}) {
                Image(systemName: action.icon)
            }.buttonStyle(ActionButtonStyle()))
        } else {
            return AnyView(EmptyView())
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
