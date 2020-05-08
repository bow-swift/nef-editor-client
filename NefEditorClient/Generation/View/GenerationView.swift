import SwiftUI
import AuthenticationServices

struct GenerationView: View {
    @Environment(\.colorScheme) var colorScheme
    let authentication: AuthenticationState
    let item: CatalogItem
    
    var body: some View {
        VStack {
            DependencyListView(dependencies: [bowDependency, bowArchDependency], isEditable: false, onRemoveDependency: { _ in })
            
            Rectangle()
                .fill(Color.gray.opacity(0.7))
                .frame(height: 2)
            
            self.bottomView
        }.navigationBarTitle("Generate nef Playground", displayMode: .inline)
        .navigationBarItems(leading:
            Button("Cancel") {
                
            }.foregroundColor(.nef)
        )
    }
    
    var style: ASAuthorizationAppleIDButton.Style {
        (self.colorScheme == .dark) ? .white : .black
    }
    
    var bottomView: some View {
        Group {
            if authentication == .unauthenticated {
                self.unauthenticatedView
            } else {
                self.authenticatedView
            }
        }
    }
    
    var authenticatedView: some View {
        Button(action: { }) {
            HStack {
                Image.nefClear
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("Generate nef Playground")
            }
        }.buttonStyle(TextButtonStyle())
        .padding()
    }
        
    var unauthenticatedView: some View {
        Group {
            Text("In order to generate your nef Playground, you need to sign in.")
                .activityStyle()
                .padding()
            
            self.signInButton
        }
    }
    
    var signInButton: some View {
        SignInButton(style: self.style) { either in
            print(either)
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
            GenerationView(authentication: .unauthenticated,
                           item: item)
            
            GenerationView(authentication: .authenticated(AuthenticationInfo(user: "", identityToken: "", authorizationCode: "")),
                           item: item)
        }.previewLayout(.fixed(width: 500, height: 500))
    }
}

#endif
