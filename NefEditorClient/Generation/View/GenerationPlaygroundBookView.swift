import SwiftUI

struct GenerationPlaygroundBookView: View {
    let playgroundName: String
    
    var body: some View {
        VStack {
            AnimationView(animation: AnimationView.Animation(lottie: .playgroundLoading, isLoop: true))
                .aspectRatio(contentMode: .fill)
                .frame(height: 448)
                
            Text(
                """
                Generating Swift Playground '\(playgroundName)'...
                
                
                Please wait, this may take several minutes.
                """
            ).activityStyle()
            .multilineTextAlignment(.center)
            
            Spacer()
        }
    }
}
