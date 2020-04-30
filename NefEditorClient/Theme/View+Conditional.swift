import Bow
import SwiftUI

extension View {
    func `if`<Then: View, Else: View>(
        _ condition: Bool,
        then f: @escaping (Self) -> Then,
        else g: @escaping (Self) -> Else
    ) -> some View {
        Group {
            if condition {
                f(self)
            } else {
                g(self)
            }
        }
    }
    
    func `if`<Then: View>(
        _ condition: Bool,
        then f: @escaping (Self) -> Then
    ) -> some View {
        self.if(condition,
                then: f,
                else: { $0 })
    }
}
