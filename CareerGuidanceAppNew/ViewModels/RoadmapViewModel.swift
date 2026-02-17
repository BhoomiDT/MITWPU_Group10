//
//  RoadmapViewModel.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/02/26.
//

import Foundation

@MainActor
class RoadmapViewModel {
    
    private(set) var roadmaps: [RoadmapDTO] = []
    
    func loadRoadmaps() async throws {
        roadmaps = try await RoadmapRepository.shared.getRoadmaps()
    }
}
