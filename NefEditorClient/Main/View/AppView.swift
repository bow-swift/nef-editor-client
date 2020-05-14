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
            self.contentView.background(
                self.backgroundView
            )
            .navigationBarItems(trailing: navigationButtons)
            
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
    
    var contentView: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                if !self.showSearch {
                    self.catalogView
                }
                self.detailView(parentSize: proxy.size)
                if self.showSearch {
                    self.searchView
                }
            }
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
            .transition(.move(edge: .leading))
            .animation(.easeInOut)
    }
    
    func detailView(parentSize: CGSize) -> some View {
        Group {
            if state.selectedItem != nil {
                detail(state.selectedItem!)
                    .frame(width: max(parentSize.width, parentSize.height) / 3)
                    .padding()
            } else {
                EmptyView().frame(width: 0)
            }
        }
        .animation(.easeInOut)
        .transition(.move(edge: .trailing))
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
