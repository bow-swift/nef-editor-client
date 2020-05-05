import SwiftUI

struct CatalogItemDetailView: View {
    let item: CatalogItem?
    let handle: (CatalogDetailAction) -> Void
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(self.item?.title ?? "")
                        .largeTitleStyle()
                    
                    Spacer()
                    
                    if self.item?.isEditable ?? false {
                        Button(action: {
                            if let item = self.item {
                                self.handle(.edit(item: item))
                            }
                        }) {
                            Image.pencil
                        }
                        .buttonStyle(ActionButtonStyle())
                    }
                    
                    Button(action: {
                        self.handle(.dismissDetail)
                    }) {
                        Image.close
                    }.buttonStyle(ActionButtonStyle())
                }
                
                Text(self.item?.description ?? "")
                    .foregroundColor(.gray)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxHeight: 2)
                    .padding(.top, 8)
                
                HStack(alignment: .center) {
                    Text("Dependencies")
                        .titleStyle()
                    
                    Spacer()
                    
                    if self.item?.isEditable ?? false {
                        Button(action: {
                            self.handle(.searchDependency)
                        }) {
                            Image.plus
                        }
                        .buttonStyle(ActionButtonStyle())
                    }
                }.padding(.top, 24)
                
                DependencyListView(
                    dependencies: self.item?.dependencies ?? [],
                    isEditable: self.item?.isEditable ?? false
                ) { dependency in
                    self.handle(.remove(dependency))
                }
                
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

#if DEBUG
struct CatalogItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogItemDetailView(item: .regular(sampleRecipe)) { _ in }
        .padding()
    }
}
#endif
