import SwiftUI

struct LoadingSearchView: View {
    let query: String
    
    var body: some View {
        LoadingView(message: "Searching Swift repositories with query '\(query)'...")
    }
}
