import SwiftUI

struct GridView<Cell: View>: View {
    let rows: Int
    let columns: Int
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let cellAt: (Int, Int) -> Cell
    
    init(
        rows: Int,
        columns: Int,
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8,
        horizontalAlignment: HorizontalAlignment = .center,
        verticalAlignment: VerticalAlignment = .center,
        @ViewBuilder cellAt: @escaping (Int, Int) -> Cell) {
        self.rows = rows
        self.columns = columns
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.cellAt = cellAt
    }
    
    var body: some View {
        VStack(alignment: self.horizontalAlignment, spacing: self.horizontalSpacing) {
            ForEach(0 ..< self.rows, id: \.self) { row in
                HStack(alignment: self.verticalAlignment, spacing: self.verticalSpacing) {
                    ForEach(0 ..< self.columns, id: \.self) { column in
                        Group {
                            if column != 0 {
                                Spacer(minLength: 0)
                            }
                            self.cellAt(row, column)
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GridView(rows: 4, columns: 3) { row, column in
                ZStack {
                    Circle().fill(Color.gray)
                    Text("\(row), \(column)")
                }
            }
            
            ScrollView {
                GridView(rows: 20, columns: 6, horizontalSpacing: 24, verticalSpacing: 16) { row, column in
                    ZStack {
                        RoundedRectangle(cornerRadius: 8).fill(Color.blue)
                        Text("\(row), \(column)")
                    }.aspectRatio(4/3, contentMode: .fit)
                }
            }
        }
    }
}
#endif
