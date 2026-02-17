//
//  RoadmapStore.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/01/26.
//

final class RoadmapStore {

    static let shared = RoadmapStore()
    private init() {}

    // Start EMPTY — backend will fill this
    private(set) var roadmaps: [Roadmap] = []

    func setRoadmaps(_ newRoadmaps: [Roadmap]) {
            self.roadmaps = newRoadmaps
        }

    func markRoadmapStarted(title: String) {
        guard let index = roadmaps.firstIndex(where: { $0.title == title }) else { return }
        roadmaps[index].isStarted = true
    }
}
