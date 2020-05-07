import SwiftUI
import GitHub

struct AppView<CatalogView: View, SearchView: View, DetailView: View, EditView: View>: View {
    let state: AppState
    let catalog: CatalogView
    let search: SearchView
    let detail: DetailView
    let edit: EditView
    let handle: (AppAction) -> Void
    
    let isEditPresented: Binding<Bool>
    
    init(state: AppState,
         catalog: CatalogView,
         search: SearchView,
         detail: DetailView,
         edit: EditView,
         handle: @escaping (AppAction) -> Void) {
        self.state = state
        self.catalog = catalog
        self.search = search
        self.detail = detail
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
    
    var showDetail: Bool {
        state.selectedItem != nil
    }
    
    var body: some View {
        NavigationView {
            HStack(spacing: 0) {
                if !showSearch {
                    catalogView
                }
                if showDetail {
                    detailView
                }
                if showSearch {
                    searchView
                }
            }.background(
                self.backgroundView
            ).navigationBarItems(trailing: navigationButtons)
            .navigationBarTitle("nef editor", displayMode: .inline)
            .modal(isPresented: isEditPresented) {
                self.edit
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.handle(.initialLoad)
        }
    }
    
    var navigationButtons: some View {
        HStack {
            if state.iCloudStatus == .disabled {
                Button(action: {}) {
                    Image.warning.foregroundColor(.yellow)
                }
            }
        }
    }
    
    var backgroundView: some View {
        Color.mainBackground
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
        if state.panelState == .catalog {
            return detail
                .frame(maxWidth: maxDetailWidth)
                .padding()
                .animation(.easeInOut)
                .transition(.move(edge: .trailing))
        } else {
            return detail
                .frame(maxWidth: maxDetailWidth)
                .padding()
                .animation(.easeInOut)
                .transition(.slide)
        }
    }
    
    var searchView: some View {
        search
            .animation(.easeInOut)
            .transition(.move(edge: .trailing))
    }
}
