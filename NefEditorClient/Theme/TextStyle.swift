import SwiftUI

extension Text {
    func largeTitleStyle() -> Text {
        self.bold().font(.largeTitle)
    }
    
    func titleStyle() -> Text {
        self.bold().font(.title)
    }
    
    func activityStyle() -> Text {
        self.font(.callout)
            .foregroundColor(Color.gray)
    }
    
    func cardTitleStyle() -> Text {
        self.font(.system(size: 20, weight: .thin, design: .rounded))
            .foregroundColor(.gray)
    }
    
    func cardBodyStyle() -> Text {
        self.font(.system(size: 20, weight: .thin, design: .rounded))
    }
}
