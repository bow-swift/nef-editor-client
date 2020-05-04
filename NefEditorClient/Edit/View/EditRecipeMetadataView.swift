import SwiftUI

struct EditRecipeMetadataView: View {
    let state: EditState
    @State var title: String
    @State var description: String
    let handle: (EditAction) -> Void
    
    init(state: EditState, handle: @escaping (EditAction) -> Void) {
        self.state = state
        
        switch state {
        case .editRecipe(let recipe):
            self._title = State(initialValue: recipe.title)
            self._description = State(initialValue: recipe.description)
        default:
            self._title = State(initialValue: "")
            self._description = State(initialValue: "")
        }
        
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
        ).navigationBarTitle(self.navigationTitle)
    }
    
    private var navigationTitle: String {
        switch state {
        case .notEditing:
            return ""
        case .newRecipe:
            return "New recipe"
        case .editRecipe(_):
            return "Edit recipe"
        }
    }
}

#if DEBUG
struct EditRecipeMetadataView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditRecipeMetadataView(
                state: .newRecipe) { _ in }
                .navigationBarTitle("Edit recipe")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
#endif
