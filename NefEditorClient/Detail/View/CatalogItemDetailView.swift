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
                
                HStack(alignment: .lastTextBaseline) {
                    Text("Dependencies")
                        .titleStyle()
                    
                    Spacer()
                    
                    Button("Add") {
                        self.switchViews.toggle()
                    }
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
