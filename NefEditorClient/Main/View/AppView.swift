import SwiftUI
import GitHub

struct AppView<CatalogView: View, SearchView: View, DetailView: View, ModalView: View>: View {
    let state: AppState
    let catalog: CatalogView
    let search: SearchView
    let detail: (CatalogItem) -> DetailView
    let modal: (AppModalState) -> ModalView
    let handle: (AppAction) -> Void
    
    let isModalPresented: Binding<Bool>
    let isAlertPresented: Binding<Bool>
    
    init(state: AppState,
         catalog: CatalogView,
         search: SearchView,
         detail: @escaping (CatalogItem) -> DetailView,
         modal: @escaping (AppModalState) -> ModalView,
         handle: @escaping (AppAction) -> Void) {
        self.state = state
        self.catalog = catalog
        self.search = search
        self.detail = detail
        self.modal = modal
        self.handle = handle
        
        self.isModalPresented = Binding(
            get: { state.modalState != .noModal },
            set: { newState in
                if !newState {
                    handle(.dismissModal)
                }
            })
        
        self.isAlertPresented = Binding(
            get: { state.iCloudAlert == .shown },
            set: { newState in
                if !newState {
                    handle(.dismissICloudAlert)
                }
            }
        )
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
            .modal(isPresented: isModalPresented) {
                self.modal(self.state.modalState)
            }
            .alert(isPresented: isAlertPresented) {
                self.iCloudAlert
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.handle(.initialLoad)
        }
    }
    
    var navigationButtons: some View {
        HStack {
            if state.iCloudStatus == .disabled {
                Button(action: { self.handle(.showICloudAlert) }) {
                    Image.warning.foregroundColor(.yellow)
                }
            }
            
            Button(action: { self.handle(.showCredits) }) {
                Image.info.foregroundColor(.nef)
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
        if let item = state.selectedItem {
            if state.panelState == .catalog {
                return AnyView(detail(item)
                    .frame(maxWidth: maxDetailWidth)
                    .padding()
                    .animation(.easeInOut)
                    .transition(.move(edge: .trailing)))
            } else {
                return AnyView(detail(item)
                    .frame(maxWidth: maxDetailWidth)
                    .padding()
                    .animation(.easeInOut)
                    .transition(.slide))
            }
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var searchView: some View {
        search
            .animation(.easeInOut)
            .transition(.move(edge: .trailing))
    }
    
    var iCloudAlert: Alert {
        Alert(
            title: Text("iCloud Disabled"),
            message: Text("iCloud is disabled for this app and we will not be able to persist the changes you make. Go to settings and enable iCloud for this app."),
            primaryButton: Alert.Button.default(Text("Go to Settings")) {
                self.handle(.showSettings)
            },
            secondaryButton: Alert.Button.cancel {
                self.handle(.dismissICloudAlert)
            })
    }
}
