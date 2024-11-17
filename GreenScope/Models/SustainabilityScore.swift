//
//  SustainabilityScore.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import Foundation

struct SustainabilityScore {
    // Calculate overall sustainability score
    static func calculateScore(recyclability: Double, impact: Double, health: Double) -> Double {
        // Ensure input values are between 0 and 1
        let normalizedRecyclability = min(max(recyclability, 0), 1)
        let normalizedImpact = min(max(impact, 0), 1)
        let normalizedHealth = min(max(health, 0), 1)
        
        // Calculate weighted average (can adjust weights based on importance)
        let weights = (recyclability: 0.4, impact: 0.4, health: 0.2)
        let score = (normalizedRecyclability * weights.recyclability +
                    (1 - normalizedImpact) * weights.impact +
                    (1 - normalizedHealth) * weights.health) * 10
        
        // Round to 1 decimal place
        return round(score * 10) / 10
    }
    
    // Get rating description based on score
    static func getRating(for score: Double) -> (label: String, color: String) {
        switch score {
        case 9...:
            return ("Excellent", "#4CAF50") // Green
        case 7..<9:
            return ("Good", "#8BC34A") // Light Green
        case 5..<7:
            return ("Average", "#FFC107") // Amber
        case 3..<5:
            return ("Poor", "#FF9800") // Orange
        default:
            return ("Very Poor", "#F44336") // Red
        }
    }
}
