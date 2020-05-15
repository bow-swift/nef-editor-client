import Bow
import BowEffects
import BowArch
import Foundation
import UIKit

typealias FAQDispatcher = StateDispatcher<Any, AppState, FAQAction>

let faqDispatcher = FAQDispatcher.effectful { input in
    switch input {
    case .dismissFAQ:
        return EnvIO.pure(dismissModal())^
    default:
        return open(url: input.url)
    }
}

func open(url: URL?) -> EnvIO<Any, Error, State<AppState, Void>> {
    EnvIO.later(.main) {
        if let url = url {
            UIApplication.shared.open(url, completionHandler: nil)
        }
    }.as(.modify(id)^)^
}
