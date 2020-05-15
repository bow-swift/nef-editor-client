import BowArch

typealias AppModalComponent = StoreComponent<Any, AppModalState, AppAction, AppModalView<EditComponent, GenerationComponent, CreditsComponent, FAQComponent>>

func appModalComponent(state: AppModalState) -> AppModalComponent {
    AppModalComponent(initialState: state) { state, handle in
        AppModalView(
            state: state,
            
            editView: { editState in
                editComponent(state: editState)
                    .using(handle, transformInput: AppAction.prism(for: AppAction.editAction))
            },
            
            generationView: { generationState in
                generationComponent(state: generationState)
                    .using(handle, transformInput: AppAction.prism(for: AppAction.generationAction))
            },
         
            creditsView: creditsComponent()
                .using(handle, transformInput: AppAction.prism(for: AppAction.creditsAction)),
            
            faqView: faqComponent()
                .using(handle, transformInput: AppAction.prism(for: AppAction.faqAction))
        )
    }
}
