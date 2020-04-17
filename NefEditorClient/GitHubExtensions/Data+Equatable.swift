import GitHub

extension Repository: Equatable {
    public static func ==(lhs: Repository, rhs: Repository) -> Bool {
        lhs.fullName == rhs.fullName
    }
}
