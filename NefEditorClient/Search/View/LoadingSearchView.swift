import SwiftUI

struct LoadingSearchView: View {
    let query: String
    
    var body: some View {
        AnimationView()
            .activityStyle(message: "Searching Swift repositories with query '\(query)'...")
    }
}
