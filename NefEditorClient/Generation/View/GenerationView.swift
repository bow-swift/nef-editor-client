import SwiftUI
import AuthenticationServices

struct GenerationView: View {
    @Environment(\.colorScheme) var colorScheme
    let state: GenerationState
    let handle: (GenerationAction) -> Void
    @State var showAlert = false
    
    var body: some View {
        self.contentView
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Generation is still not available."))
            }
            .navigationBarTitle("Generate nef Playground", displayMode: .inline)
            .navigationBarItems(leading:
                Button("Cancel") {
                    self.handle(.dismissGeneration)
                }.foregroundColor(.nef)
            )
    }
    
    var contentView: some View {
        switch state {
        case .notGenerating:
            return AnyView(EmptyView())
        case let .initial(authentication, item):
            return AnyView(initialView(authentication: authentication, item: item))
        case .generating(_):
            return AnyView(EmptyView())
        case let .error(generationError):
            return AnyView(GenerationErrorView(message: generationError.description))
        }
    }
    
    func initialView(authentication: AuthenticationState, item: CatalogItem) -> some View {
        VStack {
            DependencyListView(dependencies: item.dependencies, isEditable: false, onRemoveDependency: { _ in })

            Rectangle()
                .fill(Color.gray.opacity(0.7))
                .frame(height: 2)

            self.bottomView(authentication: authentication, item: item)
        }
    }
    
    var style: ASAuthorizationAppleIDButton.Style {
        (self.colorScheme == .dark) ? .white : .black
    }
    
    func bottomView(authentication: AuthenticationState, item: CatalogItem) -> some View {
        Group {
            if authentication == .unauthenticated {
                self.unauthenticatedView(item: item)
            } else {
                self.authenticatedView
            }
        }
    }
    
    var authenticatedView: some View {
        Button(action: { self.showAlert = true }) {
            HStack {
                Image.nefClear
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("Generate Swift Playground")
            }
        }.buttonStyle(TextButtonStyle())
        .padding()
    }
        
    func unauthenticatedView(item: CatalogItem) -> some View {
        Group {
            Text("In order to generate your nef Playground, you need to sign in.")
                .activityStyle()
                .padding()
            
            self.signInButton(item: item)
        }
    }
    
    func signInButton(item: CatalogItem) -> some View {
        SignInButton(style: self.style) { result in
            self.handle(.authenticationResult(result, item: item))
        }.frame(height: 56)
        .padding()
    }
}

#if DEBUG

struct GenerationView_Previews: PreviewProvider {
    static var item: CatalogItem {
        Catalog.initial.featured.items[0]
    }
    
    static var previews: some View {
        Group {
            GenerationView(state: .initial(.unauthenticated, item)) { _ in }
            
            GenerationView(state: .initial(.authenticated(AuthenticationInfo(user: "", identityToken: "", authorizationCode: "")), item)) { _ in }
            
        }.previewLayout(.fixed(width: 500, height: 500))
    }
}

#endif
