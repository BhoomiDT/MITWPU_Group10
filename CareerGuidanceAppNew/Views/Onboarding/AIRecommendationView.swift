import SwiftUI

struct AIRecommendationView: View {
    let domain: String
    var onBeginJourney: () -> Void
    
    // Mock data - in a real app, these could come from a Service
    let salaryRange: String = "$95,000 - $160,000"
    let coreSkills: [String] = ["Problem Solving", "Technical Logic", "System Design", "Adaptability"]
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "#0F172A").ignoresSafeArea()
            
            // Glowing Orbs for atmosphere
            Circle()
                .fill(Color.teal.opacity(0.15))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: -150, y: -200)
            
            Circle()
                .fill(Color.purple.opacity(0.1))
                .frame(width: 400, height: 400)
                .blur(radius: 100)
                .offset(x: 150, y: 300)
            
            VStack(spacing: 25) {
                VStack(spacing: 8) {
                    Text("AI Recommendation Found")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.teal)
                        .kerning(1.2)
                    
                    Text("Your Optimized Path")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.top, 40)
                
                // Glass Card
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.teal, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 80, height: 80)
                            .opacity(0.2)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 40))
                            .foregroundStyle(LinearGradient(colors: [.teal, .cyan], startPoint: .top, endPoint: .bottom))
                    }
                    
                    VStack(spacing: 4) {
                        Text(domain.uppercased())
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Based on your Profile & Goals")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    // Salary Info
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ESTIMATED ANNUAL SALARY")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.gray)
                            Text(salaryRange)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.teal)
                        }
                        Spacer()
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(.teal)
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(16)
                    
                    // Skills Grid
                    VStack(alignment: .leading, spacing: 12) {
                        Text("CORE SKILLS REQUIRED")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.gray)
                        
                        FlowLayout(items: coreSkills) { skill in
                            Text(skill)
                                .font(.system(size: 12, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.teal.opacity(0.1))
                                .foregroundColor(.teal)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.teal.opacity(0.3), lineWidth: 1))
                        }
                    }
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .cornerRadius(32)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Action
                Button(action: onBeginJourney) {
                    HStack {
                        Text("Begin Your Journey")
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(Color.teal)
                    .cornerRadius(20)
                    .shadow(color: Color.teal.opacity(0.3), radius: 20, x: 0, y: 10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
    }
}

// Helper for the Skill Tags
struct FlowLayout<Content: View>: View {
    let items: [String]
    let content: (String) -> Content
    
    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                content(item)
            }
        }
    }
}

// Extension for Hex Colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
