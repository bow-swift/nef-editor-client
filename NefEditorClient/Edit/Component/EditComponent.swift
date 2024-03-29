import BowArch

typealias EditComponent = StoreComponent<Any, EditState, EditAction, EditRecipeMetadataView>

func editComponent(state: EditState) -> EditComponent {
    EditComponent(
        initialState: state,
        render: EditRecipeMetadataView.init)
}
