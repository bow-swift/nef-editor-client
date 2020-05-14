import SwiftUI

struct AppModalView<EditView: View, GenerationView: View, CreditsView: View>: View {
    let state: AppModalState
    let editView: (EditState) -> EditView
    let generationView: (GenerationState) -> GenerationView
    let creditsView: CreditsView
    
    var body: some View {
        switch state {
        case .noModal:
            return AnyView(EmptyView())
        case .edit(let editState):
            return AnyView(editView(editState))
        case .credits:
            return AnyView(creditsView)
        case .generation(let generationState):
            return AnyView(generationView(generationState))
        }
    }
}
