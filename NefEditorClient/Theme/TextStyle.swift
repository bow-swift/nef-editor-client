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
    
    func cardTitleStyle() -> some View {
        self.scaledFont(.system(desiredSize: 20, weight: .thin))
            .foregroundColor(.gray)
    }
    
    func cardBodyStyle() -> some View {
        self.scaledFont(.system(desiredSize: 20, weight: .thin))
    }
}
