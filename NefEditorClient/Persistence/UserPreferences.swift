import Foundation

struct UserPreferences: Codable {
    let lastVersionShown: String
}

enum UserPreferencesError: Error {
    case invalidData
}
