import SwiftUI

struct RecipeDetailView: View {
    @Binding var switchViews: Bool
    
    var body: some View {
        Button("Toggle mode") {
            self.switchViews.toggle()
        }
    }
}
