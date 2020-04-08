import SwiftUI

struct RegularRecipeView: View {
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Recipe title")
                    .titleStyle()
                Text("No description provided")
                    .activityStyle()
                
                Spacer()
                HStack(spacing: 4) {
                    TagView(text: "bow")
                    TagView(text: "bow-arch")
                    TagView(text: "+3")
                    Spacer()
                }
            }.padding()
        }
    }
}

struct RegularRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RegularRecipeView()
            .aspectRatio(16/9, contentMode: .fit)
            .frame(maxWidth: 300, maxHeight: 300)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
