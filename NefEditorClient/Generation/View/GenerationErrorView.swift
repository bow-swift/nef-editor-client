import SwiftUI

struct GenerationErrorView: View {
    let message: String
    
    var body: some View {
        VStack {
            AnimationView(animation: .init(lottie: .generalError))
                .aspectRatio(contentMode: .fit)
                .frame(width: 256, height: 256)
            
            Text(message).activityStyle()
            Spacer()
        }.padding(.top, 56)
    }
}
