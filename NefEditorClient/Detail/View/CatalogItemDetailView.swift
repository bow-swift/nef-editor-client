import SwiftUI

struct CatalogItemDetailView: View {
    let item: CatalogItem
    @Binding var switchViews: Bool
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                Text(self.item.title)
                    .largeTitleStyle()
                
                Text(self.item.description)
                
                HStack(alignment: .center) {
                    Text("Dependencies")
                        .titleStyle()
                    
                    Spacer()
                    
                    Button(action: { self.switchViews.toggle() }) {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(ActionButtonStyle())
                    
                    .frame(width: 44, height: 44)
                }.padding(.top, 24)
                
                DependencyListView(dependencies: self.item.dependencies)
            }.padding()
        }
    }
}

struct CatalogItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogItemDetailView(
            item: .regular(sampleRecipe),
            switchViews: .constant(true))
        .padding()
    }
}
