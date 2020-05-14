import SwiftUI
import GitHub

struct RepositoryGridView: View {
    let repositories: [Repository]
    let columns: Int
    let onRepositorySelected: (Repository) -> ()
    
    var body: some View {
        GridView(rows: self.rows, columns: self.columns) { row, column in
            self.viewForItemAt(row, column)
                .aspectRatio(16/9, contentMode: .fit)
                .frame(width: 340)
                .onTapGesture {
                    if let repository = self.itemAt(row, column) {
                        self.onRepositorySelected(repository)
                    }
                }
        }
    }
    
    private var rows: Int {
        Int(ceil(Double(repositories.count) / Double(columns)))
    }
    
    private func itemAt(_ row: Int, _ column: Int) -> Repository? {
        repositories[safe: indexAt(row, column)]
    }
    
    private func indexAt(_ row: Int, _ column: Int) -> Int {
        row * self.columns + column
    }
    
    private func viewForItemAt(_ row: Int, _ column: Int) -> some View {
        if let repository = itemAt(row, column) {
            return AnyView(RepositoryView(repository: repository))
        } else {
            return AnyView(Color.clear)
        }
    }
}

#if DEBUG
struct RepositoryGridView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            RepositoryGridView(repositories: sampleRepos, columns: 3) { _ in }
            
            ScrollView {
                RepositoryGridView(repositories: sampleRepos, columns: 3) { _ in }
            }
        }
    }
}
#endif
