import SwiftUI
import GitHub

struct AppView<SearchView: View, RepoDetails: View>: View {
    let state: AppState
    let search: SearchView
    let detail: (SearchModalState) -> RepoDetails
    let handle: (AppAction) -> Void
    
    let isModalPresented: Binding<Bool>
    
    init(state: AppState,
         search: SearchView,
         detail: @escaping (SearchModalState) -> RepoDetails,
         handle: @escaping (AppAction) -> Void) {
        self.state = state
        self.search = search
        self.detail = detail
        self.handle = handle
        self.isModalPresented = Binding(
            get: { state.shouldShowModal },
            set: { newValue in
                if !newValue {
                    handle(.dismissModal)
                }
            })
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
            .sheet(isPresented: isModalPresented) {
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
        CatalogItemDetailView(item: state.selectedItem, handle: self.handle)
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
        switch (state.editState, state.searchState.modalState) {
        case (.notEditing, .noModal):
            return AnyView(EmptyView())
        case (.newRecipe, _):
            return AnyView(
                EditRecipeMetadataView(title: "", description: "", handle: self.handle)
                    .navigationBarTitle("New recipe")
            )
        case (.editRecipe(let recipe), _):
            return AnyView(
                EditRecipeMetadataView(title: recipe.title, description: recipe.description, handle: self.handle)
                .navigationBarTitle("Edit recipe")
            )
        case (_, _):
            return AnyView(
                self.detail(state.searchState.modalState)
            )
        }
    }
}
