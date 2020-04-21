import GitHub
import SwiftUI

#if DEBUG

let bow = Repository(
    name: "bow",
    fullName: "bow-swift/bow",
    _description: "🏹 Bow is a library for Typed Functional Programming in Swift",
    _private: false,
    htmlUrl: "https://github.com/bow-swift/bow",
    stargazersCount: 407,
    owner: Owner(login: "bow-swift", avatarUrl: "https://avatars2.githubusercontent.com/u/44965417?s=200&v=4"))

let nef = Repository(
    name: "nef",
    fullName: "bow-swift/nef",
    _description: "💊 steroids for Xcode Playgrounds",
    _private: false,
    htmlUrl: "https://github.com/bow-swift/nef",
    stargazersCount: 134,
    owner: Owner(login: "bow-swift", avatarUrl: "https://avatars2.githubusercontent.com/u/44965417?s=200&v=4"))

let version = Requirement.version(Tag(name: "0.7.5"))
let branch = Requirement.branch(Branch(name: "master"))

let sampleRepo = bow
let sampleRepos = Array(repeating: bow, count: 17)
let sampleSearchResults = [bow, nef]

let sampleBowTag = TagViewModel(text: "bow")
let sampleNefTag = TagViewModel(text: "nef", foregroundColor: .yellow, backgroundColor: .purple)

let sampleRequirements = Array(repeating: version, count: 5) + Array(repeating: branch, count: 3)

let bowDependency = Dependency(
    repository: "bow",
    url: "https://github.com/bow-swift/bow",
    requirement: .version(Tag(name: "0.7.0")))

let bowArchDependency = Dependency(
    repository: "bow-arch",
    url: "https://github.com/bow-swift/bow-arch",
    requirement: .branch(Branch(name: "master")))

let sampleRecipe = Recipe(
    title: "FP Basics",
    description: "Learn Functional Programming",
    dependencies: [
        bowDependency,
        bowArchDependency
    ])

let sampleRecipes = Array(repeating: sampleRecipe, count: 13).map(CatalogItem.regular)

let sampleFeaturedRecipe = FeaturedRecipe(
    recipe: sampleRecipe,
    backgroundImage: "bow-background",
    textColor: .white)

let sampleFeaturedRecipes = Array(repeating: sampleFeaturedRecipe, count: 2).map(CatalogItem.featured)

let sampleRecipesSection = CatalogSection(
    title: "My recipes",
    action: CatalogSectionAction(icon: "plus", action: .addRecipe),
    items: sampleRecipes)
let sampleFeaturedSection = CatalogSection(
    title: "Featured",
    items: sampleFeaturedRecipes)

let sampleCatalog = Catalog(sections: [sampleFeaturedSection, sampleRecipesSection])
#endif
