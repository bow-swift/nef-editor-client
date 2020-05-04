import SwiftUI

struct SearchBar: UIViewRepresentable {
    let placeholder: String
    @Binding var query: String
    let barStyle: UIBarStyle
    let onSearch: (String) -> Void
    
    init(placeholder: String,
         query: Binding<String>,
         barStyle: UIBarStyle = .default,
         onSearch: @escaping (String) -> Void) {
        self.placeholder = placeholder
        self._query = query
        self.barStyle = barStyle
        self.onSearch = onSearch
    }
    
    class SearchCoordinator: NSObject, UISearchBarDelegate {
        @Binding var query: String
        let onSearch: (String) -> Void
        
        init(query: Binding<String>, onSearch: @escaping (String) -> Void) {
            self._query = query
            self.onSearch = onSearch
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.query = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            self.onSearch(self.query)
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.placeholder = self.placeholder
        searchBar.barStyle = self.barStyle
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = query
    }

    func makeCoordinator() -> SearchCoordinator {
        SearchCoordinator(query: $query, onSearch: self.onSearch)
    }
}

#if DEBUG
struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBar(placeholder: "Search repository...",
                      query: .constant(""),
                      onSearch: { _ in })
                .previewLayout(.sizeThatFits)
            
            SearchBar(placeholder: "Search repository...",
                      query: .constant("Bow"),
                      barStyle: .black,
                      onSearch: { _ in })
            .previewLayout(.sizeThatFits)
        }
    }
}
#endif
