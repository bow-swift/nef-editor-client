import BowArch

typealias CreditsComponent = StoreComponent<Any, Any, CreditsAction, CreditsView>

func creditsComponent() -> CreditsComponent {
    CreditsComponent(initialState: ()) { _, handle in
        CreditsView(handle: handle)
    }
}
