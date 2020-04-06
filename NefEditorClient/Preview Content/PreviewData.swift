import GitHub

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

let sampleRepo = bow
let sampleRepos = Array(repeating: bow, count: 17)
let sampleSearchResults = [bow, nef]
#endif
