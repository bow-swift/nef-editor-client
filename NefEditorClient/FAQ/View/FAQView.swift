import SwiftUI

struct FAQView: View {
    let handle: (FAQAction) -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Group {
                    questionView(
                        question: "How does this app work?",
                        answer:
                    """
                    nef is an Open Source project developed at 47 Degrees. It started as a command line tool to increase the capabilities of Swift Playgrounds, and now it can be used from your iPad.

                    nef lets you select your favorite Swift Packages, create a recipe, and build a Swift Playground where you can enjoy using your selected libraries.

                    In order to do so, your dependencies will be downloaded in our server, and put together into a Swift Playground Book that you will receive.
                    """)
                    
                    link(text: "Visit nef GitHub repository", action: .visitNef)
                    
                    link(text: "Visit 47 Degrees website", action: .visit47Degrees)
                }
                
                Rectangle.separator
                
                Group {
                    questionView(
                        question: "Does it work for every Swift repository?",
                        answer:
                        """
                        No, unfortunately not. Your repository should have a Package.swift manifest describing your library and its dependencies, but even having this may not be enough. The Swift runtime in the iPad is a little bit limited, and there may be things that do not work as expected.

                        Also, if your repository contains Objective-C code, performs very low level operations, or uses functions like print, there are a lot of chances it will not work properly on Swift Playgrounds.
                        """)
                }
                Rectangle.separator
                
                Group {
                    questionView(
                        question: "I cannot find my repository in the Search panel",
                        answer:
                        """
                        We use GitHub to search only Swift repositories. If your repository is marked by Swift as using a different language, we may not be able to retrieve it.
                        """)
                }
                
                Rectangle.separator
                
                Group {
                    questionView(
                        question: "What can I do to contribute?",
                        answer:
                        """
                        nef, and the libraries that power it, are Open Source, and part of the Bow-Swift organization. Feel free to open issues, or make pull requests to any of our repositories.

                        Even if you cannot contribute, just sharing on Twitter or starring our projects gives us motivation to continue working on this.
                        """)
                    
                    link(text: "Visit bow-swift on GitHub", action: .visitBowSwift)
                    
                    link(text: "Follow @bow-swift on Twitter", action: .followBowSwift)
                }
                
                Rectangle.separator
                
                Group {
                    questionView(
                        question: "Which libraries are used in this app?",
                        answer:
                    """
                    nef Playgrounds is built entirely using Functional Programming, based on Bow, Bow OpenAPI, and Bow Arch.

                    The user interface is built using only SwiftUI. Animations are powered by Lottie.
                    """)
                }
            }.padding()
        }
        .navigationBarTitle("F.A.Q.", displayMode: .inline)
        .navigationBarItems(leading:
            Button("Cancel") {
                self.handle(.dismissFAQ)
            }.navigationBarButtonStyle()
        )
    }
    
    func questionView(question: String, answer: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(question)
                    .titleStyle()
                
                Text(answer)
                    .activityStyle()
                    .lineLimit(.max)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity)
                    .padding(.leading, 16)
            }
            Spacer(minLength: 0)
        }
    }
    
    func link(text: String, action: FAQAction) -> some View {
        Button(text) {
            self.handle(action)
        }.foregroundColor(.nef)
        .safeHoverEffect()
    }
}

#if DEBUG
struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FAQView() { _ in }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .previewLayout(.fixed(width: 500, height: 1550))
    }
}

#endif
