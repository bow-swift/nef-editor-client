import SwiftUI

struct AppView: View {
    @State var showSearch: Bool
    
    var body: some View {
        NavigationView {
            HStack {
                if !showSearch {
                    self.catalog
                }
                self.detail
                if showSearch {
                    self.search
                }
            }.navigationBarTitle("nef editor")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    var catalog: some View {
        RecipeCatalogView()
            .animation(.easeInOut)
            .transition(.move(edge: .leading))
    }
    
    var maxDetailWidth: CGFloat {
        max(UIScreen.main.bounds.width,
            UIScreen.main.bounds.height) / 3
    }
    
    var detail: some View {
        RecipeDetailView()
            .frame(maxWidth: maxDetailWidth)
            .animation(.easeInOut)
            .transition(.slide)
    }
    
    var search: some View {
        SearchView()
            .animation(.easeInOut)
            .transition(.move(edge: .trailing))
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AppView(showSearch: false)
            AppView(showSearch: true)
        }
    }
}
