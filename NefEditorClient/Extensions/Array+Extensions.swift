import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        (index >= 0 && index < self.count) ?
            self[index] :
            nil
    }
}
