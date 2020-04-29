import SwiftUI
import GitHub

struct AppView<CatalogView: View, SearchView: View, RepoDetails: View>: View {
    let state: AppState
    let catalog: CatalogView
    let search: SearchView
    let detail: RepoDetails
    let handle: (AppAction) -> Void
    
    let isEditPresented: Binding<Bool>
    let isDetailPresented: Binding<Bool>
    
    init(state: AppState,
         catalog: CatalogView,
         search: SearchView,
         detail: RepoDetails,
         handle: @escaping (AppAction) -> Void) {
        self.state = state
        self.catalog = catalog
        self.search = search
        self.detail = detail
        self.handle = handle
        
        self.isEditPresented = Binding(
            get: { state.editState != .notEditing },
            set: { newState in
                if !newState {
                    handle(.dismissModal)
                }
            })
        
        self.isDetailPresented = Binding(
            get: { state.searchState.modalState != .noModal },
            set: { newState in
                if !newState {
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
            .modal(isPresented: isEditPresented) {
                self.sheetView(self.editView)
            }
            .modal(isPresented: isDetailPresented) {
                self.sheetView(self.detail)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    var backgroundView: some View {
        Color.gray.opacity(0.1)
            .edgesIgnoringSafeArea(.all)
    }
    
    var catalogView: some View {
        catalog
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
    
    func sheetView<V: View>(_ content: V) -> some View {
        NavigationView {
            content
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    var editView: some View {
        switch (state.editState) {
        case .notEditing:
            return AnyView(EmptyView())
        case .newRecipe:
            return AnyView(
                EditRecipeMetadataView(title: "", description: "", handle: self.handle)
                    .navigationBarTitle("New recipe")
            )
        case .editRecipe(let recipe):
            return AnyView(
                EditRecipeMetadataView(title: recipe.title, description: recipe.description, handle: self.handle)
                .navigationBarTitle("Edit recipe")
            )
        }
    }
}
