import SwiftUI

struct DependencyListView: View {
    let dependencies: [Dependency]
    let isEditable: Bool
    let onRemoveDependency: (Dependency) -> Void
    
    var body: some View {
        List {
            ForEach(Array(dependencies.enumerated()), id: \.element.id) { item in
                DependencyView(dependency: item.element)
                    .if(self.isEditable) { view in
                        view.contextMenu {
                            Button(action: { self.onRemoveDependency(item.element) }) {
                                Text("Delete dependency")
                                Image.trash
                            }
                        }
                    }
            }.if(isEditable) { view in
                view.onDelete { indexSet in
                    if let index = indexSet.first {
                        self.onRemoveDependency(self.dependencies[index])
                    }
                }
            }.listRowBackground(Color.card)
        }.background(Color.clear)
    }
}

#if DEBUG
struct DependencyListView_Previews: PreviewProvider {
    static var previews: some View {
        DependencyListView(dependencies: Array(repeating: bowDependency, count: 15),
                           isEditable: false) { _ in }
    }
}
#endif
