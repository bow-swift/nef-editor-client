import SwiftUI

struct GenerationSigninView: View {
    var body: some View {
        VStack {
            AnimationView(animation: AnimationView.Animation(lottie: .generalLoading, isLoop: true))
                .aspectRatio(contentMode: .fill)
                .frame(width: 400, height: 200)
                .activityStyle(message: "Signing in...")
            Spacer()
        }.padding(.top, 56)
    }
}
