//
//  ProductService.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import Foundation

class ProductService {
    private let baseUrl = "https://api.openfoodfacts.org/product/"
    
    func fetchProductDetails(byBarcode barcode: String, completion: @escaping (Result<Product, ProductError>) -> Void) {
        let endpoint = "\(baseUrl)\(barcode).json"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let openFoodFactsResponse = try JSONDecoder().decode(OpenFoodFactsResponse.self, from: data)
                guard let productData = openFoodFactsResponse.product else {
                    completion(.failure(.productNotFound))
                    return
                }
                
                // Convert OpenFoodFacts product to our Product model
                let product = Product(
                    name: productData.productName,
                    description: productData.genericName ?? "No description available",
                    brand: productData.brands ?? "Unknown brand",
                    ingredients: productData.ingredients?.map { $0.text } ?? [],
                    imageUrl: productData.imageUrl ?? "",
                    sustainabilityScore: self.calculateSustainabilityScore(from: productData),
                    recyclabilityInfo: productData.packaging ?? "No recycling information available",
                    environmentalImpact: productData.environmentalImpact ?? "No environmental impact data available",
                    healthEffects: productData.nutriscoreGrade ?? "No health data available"
                )
                
                completion(.success(product))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    private func calculateSustainabilityScore(from product: OpenFoodFactsProduct) -> Double {
        // Implement your sustainability score calculation logic here
        // This is a placeholder implementation
        return 5.0
    }
}

// MARK: - Error Types
enum ProductError: Error {
    case invalidURL
    case networkError(Error)
    case noData
    case decodingError(Error)
    case productNotFound
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .productNotFound:
            return "Product not found"
        }
    }
}

// MARK: - OpenFoodFacts Response Models
struct OpenFoodFactsResponse: Codable {
    let product: OpenFoodFactsProduct?
}

struct OpenFoodFactsProduct: Codable {
    let productName: String
    let genericName: String?
    let brands: String?
    let ingredients: [Ingredient]?
    let imageUrl: String?
    let packaging: String?
    let environmentalImpact: String?
    let nutriscoreGrade: String?
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case genericName = "generic_name"
        case brands
        case ingredients
        case imageUrl = "image_url"
        case packaging
        case environmentalImpact = "environmental_impact"
        case nutriscoreGrade = "nutriscore_grade"
    }
}

struct Ingredient: Codable {
    let text: String
}
