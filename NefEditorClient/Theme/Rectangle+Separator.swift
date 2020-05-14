import SwiftUI

extension Rectangle {
    static var separator: some View {
        Rectangle()
            .fill(Color.gray)
            .frame(height: 0.5)
    }
}
