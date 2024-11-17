//
//  Product.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import Foundation

struct Product: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let brand: String
    let ingredients: [String]
    let imageUrl: String
    let sustainabilityScore: Double
    let recyclabilityInfo: String
    let environmentalImpact: String
    let healthEffects: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case brand
        case ingredients
        case imageUrl = "image_url"
        case sustainabilityScore = "sustainability_score"
        case recyclabilityInfo = "recyclability_info"
        case environmentalImpact = "environmental_impact"
        case healthEffects = "health_effects"
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        brand: String,
        ingredients: [String],
        imageUrl: String,
        sustainabilityScore: Double,
        recyclabilityInfo: String,
        environmentalImpact: String,
        healthEffects: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.brand = brand
        self.ingredients = ingredients
        self.imageUrl = imageUrl
        self.sustainabilityScore = sustainabilityScore
        self.recyclabilityInfo = recyclabilityInfo
        self.environmentalImpact = environmentalImpact
        self.healthEffects = healthEffects
    }
}
