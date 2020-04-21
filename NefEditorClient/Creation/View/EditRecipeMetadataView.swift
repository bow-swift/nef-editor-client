import SwiftUI

struct EditRecipeMetadataView: View {
    @State var title: String
    @State var description: String
    let handle: (AppAction) -> Void
    
    init(title: String, description: String, handle: @escaping (AppAction) -> Void) {
        self._title = State(initialValue: title)
        self._description = State(initialValue: description)
        self.handle = handle
    }
    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Enter a title for your nef recipe", text: $title)
            }
            
            Section(header: Text("Description")) {
                TextField("Enter a description for your nef recipe", text: $description)
            }
        }.navigationBarItems(trailing:
            Button("Save") {
                self.handle(.saveRecipe(title: self.title, description: self.description))
            }.foregroundColor(.nef)
        )
    }
}

struct EditRecipeMetadataView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditRecipeMetadataView(
                title: "New recipe",
                description: "No description provided") { _ in }
                .navigationBarTitle("Edit recipe")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
