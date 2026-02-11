//
//  CareerPredictionManager.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 02/02/26.
//

import CoreML

class CareerPredictionManager {
    static let shared = CareerPredictionManager()
    
    func getRecommendation(scores: [Double]) -> String? {
        // scores[0]=R, [1]=I, [2]=A, [3]=S, [4]=E, [5]=C
        guard scores.count == 6 else { return nil }
        
        do {
            let config = MLModelConfiguration()
          
            let model = try Career_Guidance_model(configuration: config)
            let input = Career_Guidance_modelInput(
                RealisticScore: Int64(scores[0]),
                InvestigativeScore: Int64(scores[1]),
                ArtisticScore: Int64(scores[2]),
                SocialScore: Int64(scores[3]),
                EnterprisingScore: Int64(scores[4]),
                ConventionalScore: Int64(scores[5])
            )
            
            let prediction = try model.prediction(input: input)
            return prediction.CSE_Domain
        } catch {
            print("ML Prediction Error: \(error)")
            return nil
        }
    }
}
