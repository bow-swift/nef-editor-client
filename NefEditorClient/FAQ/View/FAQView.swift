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
                    nef is an Open Source project developed by 47 Degrees. It started as a command-line tool for increasing the capabilities of Swift Playgrounds and is now available for use with iPads.

                    nef lets you select your favorite Swift Packages, create a recipe, and build a Swift Playground where you can enjoy using your libraries of choice.

                    To do so, your dependencies will be downloaded onto our server, and put together into a Swift Playground Book that you will receive.
                    """)
                    
                    link(text: "Visit nef GitHub repository", action: .visitNef)
                    
                    link(text: "Visit 47 Degrees website", action: .visit47Degrees)
                    
                    Rectangle.separator
                }
                
                Group {
                    questionView(
                        question: "Does it work for every Swift repository?",
                        answer:
                        """
                        No, unfortunately not. Your repository should have a Package.swift manifest describing your library and its dependencies, but even having this may not be enough. The Swift runtime on the iPad is slightly limited, and there may be things that do not work as expected.

                        Also, if your repository contains Objective-C code, performs very low-level operations, or uses functions like print, there is a good chance it will not work properly on Swift Playgrounds.

                        Sometimes, we will be able to fetch the repository and create a Swift Playground, but it will not run properly on the iPad. You can try editing the files in the library if you know the problematic code that prevents it from running. We have also noticed that disabling the option "Enable Results" sometimes helps make things run properly.
                        """)
                    
                    Rectangle.separator
                }
                
                Group {
                    questionView(
                        question: "I cannot find my repository in the Search panel",
                        answer:
                        """
                        We use GitHub to only search for Swift repositories. If your repository is marked by Swift as using a different language, we may not be able to retrieve it.
                        """)
                    
                    Rectangle.separator
                }
                
                Group {
                    questionView(
                        question: "What can I do to contribute?",
                        answer:
                        """
                        nef, and the libraries that power it, are Open Source, and part of the Bow-Swift organization. Feel free to open issues, or make pull requests to any of our repositories.

                        Even if you cannot contribute, just sharing on Twitter or starring our projects gives us the motivation to continue working on this.
                        """)
                    
                    link(text: "Visit bow-swift on GitHub", action: .visitBowSwift)
                    
                    link(text: "Follow @bow-swift on Twitter", action: .followBowSwift)
                    
                    Rectangle.separator
                }
                
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
        
        VStack(alignment: .leading, spacing: 16) {
            Text(question)
                .titleStyle()
            
            HStack {
                Text(answer)
                    .activityStyle()
                    .lineLimit(.max)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity)
                
                Spacer(minLength: 0)
            }
        }.frame(maxWidth: .infinity)
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
        .previewLayout(.fixed(width: 500, height: 1750))
    }
}
#endif
