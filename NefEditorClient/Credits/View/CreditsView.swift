import SwiftUI

struct CreditsView: View {
    let handle: (CreditsAction) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            self.version()
            self.sponsor()
            Spacer()
            self.librarySection()
        }.padding()
        .navigationBarTitle("Credits", displayMode: .inline)
        .navigationBarItems(leading:
            Button("Cancel") {
                self.handle(.dismissCredits)
            }.foregroundColor(Color.nef)
        )
    }
    
    var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return "Version \(version)"
        } else {
            return ""
        }
    }
    
    func version() -> some View {
        Group {
            Image.appIcon.resizable()
                .frame(width: 180, height: 180)
                .mask(RoundedRectangle(cornerRadius: 16))
                
            Text("nef editor").largeTitleStyle()

            Text(appVersion)
                .activityStyle()
        }
    }
    
    func sponsor() -> some View {
        HStack {
            Text("Proudly sponsored by")
            Image.fortySeven.resizable()
                .frame(width: 24, height: 24)
        }.padding()
    }
    
    func librarySection() -> some View {
        Group {
            Text("This application is powered by:")
                .font(.caption)
            
            HStack(alignment: .center, spacing: 4) {
                libraryView(image: .bow, name: "Bow", library: .bow)
                libraryView(image: .bowArch, name: "Bow Arch", library: .bowArch)
                libraryView(image: .bowOpenAPI, name: "Bow OpenAPI", library: .bowOpenAPI)
            }
        }
    }
    
    func libraryView(image: Image, name: String, library: Library) -> some View {
        Button(action: { self.handle(.librarySelected(library)) }) {
            HStack {
                image.resizable()
                    .frame(width: 40, height: 40)
                    .mask(RoundedRectangle(cornerRadius: 8))
                
                Text(name)
                    .font(.callout)
                
                Spacer()
            }
        }.buttonStyle(LibraryButtonStyle())
    }
}

#if DEBUG

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreditsView { _ in }
        }.navigationViewStyle(StackNavigationViewStyle())
            .previewLayout(.fixed(width: 500, height: 500))
    }
}

#endif