import SwiftUI

struct GridView<Cell: View>: View {
    let rows: Int
    let columns: Int
    let cellAt: (Int, Int) -> Cell
    
    init(rows: Int, columns: Int, @ViewBuilder cellAt: @escaping (Int, Int) -> Cell) {
        self.rows = rows
        self.columns = columns
        self.cellAt = cellAt
    }
    
    var body: some View {
        VStack {
            ForEach(0 ..< self.rows) { row in
                HStack {
                    ForEach(0 ..< self.columns) { column in
                        self.cellAt(row, column)
                    }
                }
            }
        }
    }
}
