// Data structure for the Activity cell
struct ActivityData {
    let xp: Int = 45
    let streaks: Int = 12
    let badges: Int = 23
}

// Data structure for the Roadmap section (placeholders)
struct RoadmapEntry {
    let title: String
    let description: String
}

// Enum to organize the collection view's sections
enum Group: Int, CaseIterable {
    case activity = 0 // The top section (Activity box)
    case roadmaps = 1 // The roadmaps/other content
}
