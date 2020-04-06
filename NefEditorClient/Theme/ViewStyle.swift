import SwiftUI

extension View {
    var fill: some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
