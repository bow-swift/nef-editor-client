import SwiftUI

extension View {
    
    func activityStyle(message: String) -> some View {
        VStack {
            self
            
            Text(message)
                .activityStyle()
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)
        }
    }
}
