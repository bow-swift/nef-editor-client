enum AppModalState: Equatable {
    case noModal
    case edit(EditState)
    case credits
    case generation(GenerationState)
    case faq
    
    var editState: EditState? {
        guard case let .edit(state) = self else {
            return nil
        }
        return state
    }
    
    var generationState: GenerationState? {
        guard case let .generation(state) = self else {
            return nil
        }
        return state
    }
}
