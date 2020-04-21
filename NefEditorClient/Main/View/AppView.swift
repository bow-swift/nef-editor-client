import SwiftUI

struct AppView: View {
    let state: AppState
    let search: SearchComponent
    let handle: (AppAction) -> Void
    
    let isEditPresented: Binding<Bool>
    
    init(state: AppState,
         search: SearchComponent,
         handle: @escaping (AppAction) -> Void) {
        self.state = state
        self.search = search
        self.handle = handle
        self.isEditPresented = Binding(
            get: { state.editState != .notEditing },
            set: { newValue in print("Edition dismissed!") })
    }
    
    var showSearch: Bool {
        state.panelState == .search
    }
    
    var body: some View {
        NavigationView {
            HStack(spacing: 0) {
                if !showSearch {
                    catalogView
                }
                detailView
                if showSearch {
                    searchView
                }
            }.background(
                self.backgroundView
            ).navigationBarTitle("nef editor", displayMode: .inline)
            .sheet(isPresented: isEditPresented) {
                self.sheetView
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    var backgroundView: some View {
        Color.gray.opacity(0.1)
            .edgesIgnoringSafeArea(.all)
    }
    
    var catalogView: some View {
        RecipeCatalogView(catalog: state.catalog, handle: self.handle)
            .animation(.easeInOut)
            .transition(.move(edge: .leading))
    }
    
    var maxDetailWidth: CGFloat {
        max(UIScreen.main.bounds.width,
            UIScreen.main.bounds.height) / 3
    }
    
    var detailView: some View {
        CatalogItemDetailView(item: state.selectedItem, switchViews: .constant(false))
            .frame(maxWidth: maxDetailWidth)
            .padding()
            .animation(.easeInOut)
            .transition(.slide)
    }
    
    var searchView: some View {
        search
            .animation(.easeInOut)
            .transition(.move(edge: .trailing))
    }
    
    var sheetView: some View {
        NavigationView {
            self.editView
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    var editView: some View {
        switch state.editState {
        case .notEditing:
            return AnyView(EmptyView())
        case .newRecipe:
            return AnyView(
                EditRecipeMetadataView(title: "", description: "")
                    .navigationBarTitle("New recipe")
            )
        case .editRecipe(let recipe):
            return AnyView(
                EditRecipeMetadataView(title: recipe.title, description: recipe.description)
            )
        }
    }
}
