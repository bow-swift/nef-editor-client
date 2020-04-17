import SwiftUI

struct AppView: View {
    let search: SearchComponent
    
    @State var showSearch: Bool
    
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
                Color.gray.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
            ).navigationBarTitle("nef editor", displayMode: .inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    var catalogView: some View {
        RecipeCatalogView(catalog: sampleCatalog)
            .animation(.easeInOut)
            .transition(.move(edge: .leading))
    }
    
    var maxDetailWidth: CGFloat {
        max(UIScreen.main.bounds.width,
            UIScreen.main.bounds.height) / 3
    }
    
    var detailView: some View {
        CatalogItemDetailView(item: .regular(sampleRecipe),switchViews: $showSearch)
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
