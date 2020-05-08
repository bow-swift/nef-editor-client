import BowArch

typealias GenerationComponent = StoreComponent<Any, GenerationState, GenerationAction, GenerationView>

func generationComponent(state: GenerationState) -> GenerationComponent {
    GenerationComponent(
        initialState: state) { state, handle in
        GenerationView(state: state, handle: handle)
    }
}
