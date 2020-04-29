import SwiftUI
import GitHub

struct AppView<CatalogView: View, SearchView: View, EditView: View>: View {
    let state: AppState
    let catalog: CatalogView
    let search: SearchView
    let edit: EditView
    let handle: (AppAction) -> Void
    
    let isEditPresented: Binding<Bool>
    
    init(state: AppState,
         catalog: CatalogView,
         search: SearchView,
         edit: EditView,
         handle: @escaping (AppAction) -> Void) {
        self.state = state
        self.catalog = catalog
        self.search = search
        self.edit = edit
        self.handle = handle
        
        self.isEditPresented = Binding(
            get: { state.editState != .notEditing },
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
                self.edit
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
}
