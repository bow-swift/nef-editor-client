import GitHub

extension Repository: Equatable {
    public static func ==(lhs: Repository, rhs: Repository) -> Bool {
        lhs.fullName == rhs.fullName
    }
}

extension Tag: Equatable {
    public static func ==(lhs: Tag, rhs: Tag) -> Bool {
        lhs.name == rhs.name
    }
}

extension Branch: Equatable {
    public static func ==(lhs: Branch, rhs: Branch) -> Bool {
        lhs.name == rhs.name
    }
}
