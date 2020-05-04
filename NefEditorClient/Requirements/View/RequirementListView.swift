import GitHub
import SwiftUI

struct RequirementListView: View {
    let requirements: [Requirement]
    let onRequirementSelected: (Requirement) -> ()
    
    var body: some View {
        List {
            ForEach(requirements, id: \.title) { requirement in
                Button(action: { self.onRequirementSelected(requirement) }) {
                    RequirementView(requirement: requirement)
                }
            }
        }
    }
}

#if DEBUG
struct RequirementListView_Previews: PreviewProvider {
    static var previews: some View {
        RequirementListView(requirements: sampleRequirements) { _ in }
            .previewLayout(.sizeThatFits)
    }
}
#endif
