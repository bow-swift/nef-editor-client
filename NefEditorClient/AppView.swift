import SwiftUI

struct AppView: View {
    @State var showSearch: Bool
    
    var body: some View {
        NavigationView {
            HStack {
                if !showSearch {
                   catalogView
                }
               detailView
                if showSearch {
                   searchView
                }
            }.navigationBarTitle("nef editor", displayMode: .inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    var catalogView: some View {
        RecipeCatalogView()
            .animation(.easeInOut)
            .transition(.move(edge: .leading))
    }
    
    var maxDetailWidth: CGFloat {
        max(UIScreen.main.bounds.width,
            UIScreen.main.bounds.height) / 3
    }
    
    var detailView: some View {
        RecipeDetailView(switchViews: $showSearch)
            .frame(maxWidth: maxDetailWidth)
            .animation(.easeInOut)
            .transition(.slide)
    }
    
    var searchView: some View {
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
