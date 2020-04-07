import SwiftUI

struct SearchBar: UIViewRepresentable {
    let placeholder: String
    @Binding var query: String
    let barStyle: UIBarStyle
    
    init(placeholder: String, query: Binding<String>, barStyle: UIBarStyle = .default) {
        self.placeholder = placeholder
        self._query = query
        self.barStyle = barStyle
    }
    
    class SearchCoordinator: NSObject, UISearchBarDelegate {
        @Binding var query: String
        
        init(query: Binding<String>) {
            self._query = query
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.query = searchText
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.placeholder = self.placeholder
        searchBar.barStyle = self.barStyle
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = query
    }

    func makeCoordinator() -> SearchCoordinator {
        SearchCoordinator(query: $query)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBar(placeholder: "Search repository...",
                      query: .constant(""))
                .previewLayout(.sizeThatFits)
            
            SearchBar(placeholder: "Search repository...",
                      query: .constant("Bow"),
                      barStyle: .black)
            .previewLayout(.sizeThatFits)
        }
    }
}
