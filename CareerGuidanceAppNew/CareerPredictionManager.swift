//
//  CareerPredictionManager.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 02/02/26.
//

import CoreML

class CareerPredictionManager {
    
    static let shared = CareerPredictionManager()
    
    // ALL SKILLS must match training dataset columns exactly
    let allSkills = [
        "Adobe XD","Agile","Angular","ASP.NET","AWS","Azure",
        "C","CPP","Django","Docker",
        "Figma","Flutter","GCP","Go","GraphQL",
        "Hadoop","HTML","CSS","Java","JavaScript","Jenkins",
        "Jetpack Compose","Kotlin","Kubernetes","Linux",
        "NLP","Node.js","NumPy","Pandas","Python","PyTorch",
        "React","React Native","REST API","Ruby","Rust",
        "Scikit-Learn","Scrum","Spark","Spring Boot","SQL",
        "Swift","SwiftUI","System Design","Tableau","TensorFlow",
        "Terraform","TypeScript","Unit Testing","Vue"
    ]
    
    func getTopThreeRecommendations(scores: [Double], skills: [String]) -> [(domain: String, confidence: Double)]? {
        
        guard scores.count == 6 else { return nil }
        
        do {
            let config = MLModelConfiguration()
            let model = try RIASEC_ModelV3(configuration: config)
            
            // Convert skills into binary dictionary
            var skillVector: [String: Int64] = [:]
            
            for skill in allSkills {
                skillVector[skill] = skills.contains(skill) ? 1 : 0
            }
            
            // Build model input
            let input = RIASEC_ModelV3Input(
                RealisticScore: Int64(scores[0]),
                InvestigativeScore: Int64(scores[1]),
                ArtisticScore: Int64(scores[2]),
                SocialScore: Int64(scores[3]),
                EnterprisingScore: Int64(scores[4]),
                ConventionalScore: Int64(scores[5]),
                
                Adobe_XD: skillVector["Adobe XD"]!,
                Agile: skillVector["Agile"]!,
                Angular: skillVector["Angular"]!,
                ASP_NET: skillVector["ASP.NET"]!,
                AWS: skillVector["AWS"]!,
                Azure: skillVector["Azure"]!,
                C: skillVector["C"]!,
                CPP: skillVector["CPP"]!,
                Django: skillVector["Django"]!,
                Docker: skillVector["Docker"]!,
                Figma: skillVector["Figma"]!,
                Flutter: skillVector["Flutter"]!,
                GCP: skillVector["GCP"]!,
                Go: skillVector["Go"]!,
                GraphQL: skillVector["GraphQL"]!,
                Hadoop: skillVector["Hadoop"]!,
                HTML: skillVector["HTML"]!,
                CSS: skillVector["CSS"]!,
                Java: skillVector["Java"]!,
                JavaScript: skillVector["JavaScript"]!,
                Jenkins: skillVector["Jenkins"]!,
                Jetpack_Compose: skillVector["Jetpack Compose"]!,
                Kotlin: skillVector["Kotlin"]!,
                Kubernetes: skillVector["Kubernetes"]!,
                Linux: skillVector["Linux"]!,
                NLP: skillVector["NLP"]!,
                Node_js: skillVector["Node.js"]!,
                NumPy: skillVector["NumPy"]!,
                Pandas: skillVector["Pandas"]!,
                Python: skillVector["Python"]!,
                PyTorch: skillVector["PyTorch"]!,
                React: skillVector["React"]!,
                React_Native: skillVector["React Native"]!,
                REST_API: skillVector["REST API"]!,
                Ruby: skillVector["Ruby"]!,
                Rust: skillVector["Rust"]!,
                Scikit_Learn: skillVector["Scikit-Learn"]!,
                Scrum: skillVector["Scrum"]!,
                Spark: skillVector["Spark"]!,
                Spring_Boot: skillVector["Spring Boot"]!,
                SQL: skillVector["SQL"]!,
                Swift: skillVector["Swift"]!,
                SwiftUI: skillVector["SwiftUI"]!,
                System_Design: skillVector["System Design"]!,
                Tableau: skillVector["Tableau"]!,
                TensorFlow: skillVector["TensorFlow"]!,
                Terraform: skillVector["Terraform"]!,
                TypeScript: skillVector["TypeScript"]!,
                Unit_Testing: skillVector["Unit Testing"]!,
                Vue: skillVector["Vue"]!
            )
            
            let output = try model.prediction(input: input)
            
            let probabilities = output.CSE_DomainProbability
            
            let sortedResults = probabilities.sorted { $0.value > $1.value }
            
            let topThree = sortedResults.prefix(3).map {
                (domain: $0.key, confidence: $0.value)
            }
            
            return topThree
            
        } catch {
            print("Model error:", error)
            return nil
        }
    }
}
