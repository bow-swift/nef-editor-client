import SwiftUI

struct TagViewModel {
    let text: String
    let foregroundColor: Color
    let backgroundColor: Color
    
    init(text: String, foregroundColor: Color = .gray, backgroundColor: Color = Color.gray.opacity(0.2)) {
        self.text = text
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
}
