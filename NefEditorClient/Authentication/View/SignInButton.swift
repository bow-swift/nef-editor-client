import Bow
import SwiftUI
import AuthenticationServices

struct SignInButton: UIViewRepresentable {
    let style: ASAuthorizationAppleIDButton.Style
    let onSignIn: (Either<Error, AuthenticationInfo>) -> Void
    
    class Coordinator: NSObject, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
        let onSignIn: (Either<Error, AuthenticationInfo>) -> Void
        
        init(onSignIn: @escaping (Either<Error, AuthenticationInfo>) -> Void) {
            self.onSignIn = onSignIn
        }
        
        @objc func didTapButton() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.presentationContextProvider = self
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
        
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            let lastController = UIApplication.shared.windows.last?.rootViewController
            return lastController!.view.window!
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let identityTokenRaw = credentials.identityToken,
                  let authorizationCodeRaw = credentials.authorizationCode,
                  let identityToken = String(data: identityTokenRaw, encoding: .utf8),
                  let authorizationCode = String(data: authorizationCodeRaw, encoding: .utf8) else {
                    onSignIn(.left(ASAuthorizationError(ASAuthorizationError.failed)))
                    return
            }
            
            let info = AuthenticationInfo(
                user: credentials.user,
                identityToken: identityToken,
                authorizationCode: authorizationCode)
            
            onSignIn(.right(info))
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            onSignIn(.left(error))
        }
    }
    
    func makeCoordinator() -> SignInButton.Coordinator {
        Coordinator(onSignIn: onSignIn)
    }
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn,
                                                  authorizationButtonStyle: style)
        button.addTarget(context.coordinator,
                         action: #selector(Coordinator.didTapButton),
                         for: .touchUpInside)
        return button
    }

    func updateUIView(_ button: ASAuthorizationAppleIDButton, context: Context) -> Void {}
}
