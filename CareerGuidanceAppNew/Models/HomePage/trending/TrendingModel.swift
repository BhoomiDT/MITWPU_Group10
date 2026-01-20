import Foundation

struct TrendingItem {
    let title: String
    let description: String
    let imageName: String
}

struct TrendingModel {
    static let sampleData: [TrendingItem] = [
        TrendingItem(
            title: "AI & Machine Learning",
            description: "Teaching machines to learn and make smart decisions.",
            imageName: "aiml-role"
        ),
        TrendingItem(
            title: "Web Development",
            description: "Building responsive websites and web applications.",
            imageName: "appdev-role 1"
        ),
        TrendingItem(
            title: "Cyber Security",
            description: "Protecting systems and networks from digital attacks.",
            imageName: "cyber-security-role"
        )
    ]
}
