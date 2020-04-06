import SwiftUI
import GitHub

struct RepositoryGridView: View {
    let repositories: [Repository]
    let columns: Int
    
    var body: some View {
        GridView(rows: self.rows, columns: self.columns) { row, column in
            self.viewForItem(atIndex: self.indexAt(row, column))
                .aspectRatio(4/3, contentMode: .fit)
        }
    }
    
    private var rows: Int {
        Int(ceil(Double(repositories.count) / Double(columns)))
    }
    
    private func indexAt(_ row: Int, _ column: Int) -> Int {
        row * self.columns + column
    }
    
    private func viewForItem(atIndex index: Int) -> some View {
        if let repository = repositories[safe: index] {
            return AnyView(RepositoryView(repository: repository))
        } else {
            return AnyView(Color.clear)
        }
    }
}

struct RepositoryGridView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            RepositoryGridView(repositories: sampleRepos, columns: 3)
            
            ScrollView {
                RepositoryGridView(repositories: sampleRepos, columns: 3)
            }
        }
    }
}
