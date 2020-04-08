import GitHub
import SwiftUI

struct RequirementListView: View {
    let requirements: [Requirement]
    
    var body: some View {
        List {
            ForEach(requirements, id: \.title, content: RequirementView.init)
        }
    }
}

struct RequirementListView_Previews: PreviewProvider {
    static var previews: some View {
        RequirementListView(requirements: sampleRequirements)
            .previewLayout(.sizeThatFits)
    }
}
