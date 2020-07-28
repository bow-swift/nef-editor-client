import BowArch

typealias WhatsNewComponent = StoreComponent<Any, Any, WhatsNewAction, WhatsNewView>

func whatsNewComponent() -> WhatsNewComponent {
    WhatsNewComponent(initialState: ()) { _, handle in
        WhatsNewView(handle: handle)
    }
}
