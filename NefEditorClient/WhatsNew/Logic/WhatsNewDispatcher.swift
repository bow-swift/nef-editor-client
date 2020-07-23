import Foundation
import Bow
import BowEffects
import BowArch

typealias WhatsNewDispatcher = StateDispatcher<Persistence, AppState, WhatsNewAction>

let whatsNewDispatcher = WhatsNewDispatcher.effectful { action in
    switch action {
    case .openGenerator:
        return open(url: URL(string: "https://badge.bow-swift.io"))
    case .dismiss:
        return updateUserPreferences().map { _ in dismissModal() }^
    }
}


func updateUserPreferences() -> EnvIO<Persistence, Error, Void> {
    EnvIO.accessM { persistence in
        let bundleVersion = Bundle.main.version
        return persistence.updateUserPreferences(bundleVersion: bundleVersion)^
    }
}
