import SwiftUI

struct CatalogItemDetailView: View {
    let item: CatalogItem
    let handle: (CatalogDetailAction) -> Void
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(self.item.title)
                        .largeTitleStyle()
                    
                    Spacer()
                    
                    if self.item.isEditable{
                        Button(action: {
                            self.handle(.edit(item: self.item))
                        }) {
                            Image.pencil
                        }
                        .buttonStyle(ActionButtonStyle())
                        .offset(y: 4)
                    }
                    
                    Button(action: {
                        self.handle(.dismissDetail)
                    }) {
                        Image.close
                    }.buttonStyle(ActionButtonStyle())
                     .offset(y: 4)
                }
                
                Text(self.item.description)
                    .foregroundColor(.gray)
                
                Rectangle.separator
                    .padding(.top, 8)
                
                SectionTitle(title: "Dependencies",
                             action: .init(icon: Image.plus,
                                           handle: self.handle(.searchDependency)))
                    .padding(.top, 24)
                
                DependencyListView(
                    dependencies: self.item.dependencies,
                    isEditable: self.item.isEditable
                ) { dependency in
                    self.handle(.remove(dependency))
                }
                
                Button(action: { self.handle(.generatePlayground(for: self.item)) }) {
                    HStack(spacing: 12) {
                        Image.nefClear
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

#if DEBUG
struct CatalogItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogItemDetailView(item: .regular(sampleRecipe)) { _ in }
        .padding()
    }
}
#endif
