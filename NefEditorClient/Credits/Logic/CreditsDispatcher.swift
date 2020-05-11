import Bow
import BowArch
import BowEffects
import UIKit

typealias CreditsDispatcher = StateDispatcher<Any, AppState, CreditsAction>

let creditsDispatcher = CreditsDispatcher.effectful { input in
    switch input {
    case .librarySelected(let library):
        return open(library: library)
    case .dismissCredits:
        return EnvIO.pure(dismissModal())^
    }
}

func open(library: Library) -> EnvIO<Any, Error, State<AppState, Void>> {
    EnvIO.later(.main) {
        if let url = library.url {
            UIApplication.shared.open(url, completionHandler: nil)
        }
    }.as(.modify(id)^)^
}
