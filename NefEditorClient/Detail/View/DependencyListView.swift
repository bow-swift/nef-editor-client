import SwiftUI

struct DependencyListView: View {
    let dependencies: [Dependency]
    
    var body: some View {
        List {
            ForEach(Array(dependencies.enumerated()), id: \.offset) { item in
                DependencyView(dependency: item.element)
            }
        }
    }
}

struct DependencyListView_Previews: PreviewProvider {
    static var previews: some View {
        DependencyListView(dependencies: Array(repeating: bowDependency, count: 15))
    }
}
