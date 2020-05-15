import SwiftUI

struct GenerationSigninView: View {
    var body: some View {
        VStack {
            AnimationView(animation: AnimationView.Animation(lottie: .generalLoading, isLoop: true))
                .aspectRatio(contentMode: .fit)
                .frame(width: 256, height: 256)
                .activityStyle(message: "Signing in...")
            Spacer()
        }.padding(.top, 56)
    }
}
