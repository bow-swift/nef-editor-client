import SwiftUI

struct CatalogItemDetailView: View {
    let item: CatalogItem
    let handle: (AppAction) -> Void
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(self.item.title)
                        .largeTitleStyle()
                    
                    Spacer()
                    
                    if self.item.isEditable {
                        Button(action: { self.handle(.edit(item: self.item)) }) {
                            Image(systemName: "pencil")
                        }
                        .buttonStyle(ActionButtonStyle())
                    }
                }
                
                Text(self.item.description)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxHeight: 2)
                    .padding(.top, 8)
                
                HStack(alignment: .center) {
                    Text("Dependencies")
                        .titleStyle()
                    
                    Spacer()
                    
                    if self.item.isEditable {
                        Button(action: { self.handle(.searchDependency) }) {
                            Image(systemName: "plus")
                        }
                        .buttonStyle(ActionButtonStyle())
                    }
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
        CatalogItemDetailView(item: .regular(sampleRecipe)) { _ in }
        .padding()
    }
}
