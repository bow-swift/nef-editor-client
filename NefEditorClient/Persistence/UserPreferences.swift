import Foundation

struct UserPreferences: Codable {
    let whatsNewBundle: String
}

enum UserPreferencesError: Error {
    case notExist
    case invalidData
}
