import Foundation

extension Bundle {
    var version: String { "\(appVersion) [\(buildVersion)]" }
    
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    var buildVersion: String {
        infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
