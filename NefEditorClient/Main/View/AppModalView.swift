import SwiftUI

struct AppModalView<EditView: View, GenerationView: View, CreditsView: View, FAQView: View, WhatsNewView: View>: View {
    let state: AppModalState
    let editView: (EditState) -> EditView
    let generationView: (GenerationState) -> GenerationView
    let creditsView: CreditsView
    let faqView: FAQView
    let whatsNewView: WhatsNewView
    
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
        case .faq:
            return AnyView(faqView)
        case .whatsNew:
            return AnyView(whatsNewView)
        }
    }
}
