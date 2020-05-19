import BowArch

typealias FAQComponent = StoreComponent<Any, Any, FAQAction, FAQView>

func faqComponent() -> FAQComponent {
    FAQComponent(initialState: ()) { _, handle in
        FAQView(handle: handle)
    }
}
