import SwiftUI

struct CatalogItemDetailView: View {
    let item: CatalogItem
    @Binding var switchViews: Bool
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(self.item.title)
                        .largeTitleStyle()
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "pencil")
                    }
                    .buttonStyle(ActionButtonStyle())
                }
                
                Text(self.item.description)
                
                HStack(alignment: .center) {
                    Text("Dependencies")
                        .titleStyle()
                    
                    Spacer()
                    
                    Button(action: { self.switchViews.toggle() }) {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(ActionButtonStyle())
                }.padding(.top, 24)
                
                DependencyListView(dependencies: self.item.dependencies)
                
                Button(action: {}) {
                    HStack(spacing: 12) {
                        Image("nef")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text("Create Swift Playground")
                    }
                }.frame(maxWidth: .infinity)
                    .buttonStyle(TextButtonStyle())
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
