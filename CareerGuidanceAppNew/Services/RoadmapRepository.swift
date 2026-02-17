//
//  RoadmapRepository.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 11/02/26.
//

import Foundation

actor RoadmapRepository {
    
    static let shared = RoadmapRepository()
    
    private var cachedRoadmaps: [RoadmapDTO]?
    
    func getRoadmaps() async throws -> [RoadmapDTO] {
        
        if let cached = cachedRoadmaps {
            return cached
        }
        
        let fetched = try await RoadmapService.shared.fetchRoadmaps()
        cachedRoadmaps = fetched
        
        return fetched
    }
    
    func refreshRoadmaps() async throws -> [RoadmapDTO] {
        let fetched = try await RoadmapService.shared.fetchRoadmaps()
        cachedRoadmaps = fetched
        return fetched
    }
}
