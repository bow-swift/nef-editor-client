# nef Playgrounds

Welcome to the client-side code of **nef Playgrounds** for iPad!

nef Playgrounds is an open source application for iPad that lets you:

👨‍🍳 Create a nef recipe...

📦 ... add your favorite Swift dependencies ...

📲 ... and create a Swift Playground that you can use on your iPad!

## How does it work?

nef Playgrounds uses GitHub API to search for Swift repositories and select a branch or tag that can be used as a dependency in Swift Package Manager. Then, it communicates with [its backend](https://github.com/bow-swift/nef-editor-server), which is also open source, to generate a Swift Playground that contains the selected dependencies. This Playground is sent back to the client and users can open it in the Playgrounds app. It will let users write Swift code using the Swift Packages of their choice.

Unfortunately, this may not always work; your repository must contain only Swift code, have a `Package.swift` manifest file, and be prepared to run on the iPad (the runtime in the iPad is slightly different and there may be parts of your library that do not work properly).

## How do I run this project?

- Open the project on Xcode.
- Run the schemes `GenerateGitHubAPI` and `GenerateNefAPI`. You will need to have [Bow OpenAPI](https://openapi.bow-swift.io) installed on your Mac. These tasks will generate two folders named `GitHub` and `NefAPI` respectively.
- Add the folders to the root of the project.
- You may need to configure your app ID and create the necessary entitlements to handle Apple Sign In and iCloud storage.

## License

    Copyright (C) 2020 The nef Authors

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
