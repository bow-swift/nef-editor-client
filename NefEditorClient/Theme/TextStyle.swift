import SwiftUI

extension Text {
    func titleStyle() -> Text {
        self.bold().font(.largeTitle)
    }
    
    func activityStyle() -> Text {
        self.font(.callout)
            .foregroundColor(Color.gray)
    }
}
