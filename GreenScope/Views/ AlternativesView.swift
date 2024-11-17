//
//  AlternativesView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct AlternativesView: View {
    var alternatives: [Product]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Eco-Friendly Alternatives")
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                    .padding(.bottom, 10)
                
                if alternatives.isEmpty {
                    EmptyStateView()
                } else {
                    alternativesList
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var alternativesList: some View {
        ForEach(alternatives) { product in
            ProductCard(product: product)
        }
    }
}

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 15) {
                // Product Image
                AsyncImage(url: URL(string: product.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .overlay(
                            ProgressView()
                                .tint(.gray)
                        )
                }
                
                // Product Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(product.brand)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        SustainabilityBadge(score: product.sustainabilityScore)
                        Spacer()
                        LearnMoreButton()
                    }
                }
            }
            
            // Additional Information
            VStack(alignment: .leading, spacing: 8) {
                InfoRow(title: "Environmental Impact", description: product.environmentalImpact)
                InfoRow(title: "Recyclability", description: product.recyclabilityInfo)
                InfoRow(title: "Health Effects", description: product.healthEffects)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct SustainabilityBadge: View {
    let score: Double
    
    var scoreColor: Color {
        switch score {
        case 8...10: return .green
        case 6..<8: return .yellow
        case 4..<6: return .orange
        default: return .red
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "leaf.fill")
                .foregroundColor(scoreColor)
            Text(String(format: "%.1f", score))
                .font(.system(.subheadline, design: .rounded))
                .bold()
            Text("/10")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(scoreColor.opacity(0.1))
        .cornerRadius(8)
    }
}

struct LearnMoreButton: View {
    var body: some View {
        Button(action: {
            // Add action for learning more
        }) {
            Text("Learn More")
                .font(.caption)
                .foregroundColor(.blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
        }
    }
}

struct InfoRow: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(description)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "leaf.circle")
                .font(.system(size: 60))
                .foregroundColor(.green)
            Text("No Alternatives Found")
                .font(.headline)
            Text("We couldn't find any eco-friendly alternatives for this product at the moment.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct AlternativesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlternativesView(alternatives: [
                Product(
                    name: "Eco-Friendly Product",
                    description: "A sustainable alternative",
                    brand: "Green Brand",
                    ingredients: ["Natural ingredient 1", "Natural ingredient 2"],
                    imageUrl: "",
                    sustainabilityScore: 8.5,
                    recyclabilityInfo: "100% recyclable packaging",
                    environmentalImpact: "Low carbon footprint",
                    healthEffects: "No harmful chemicals"
                )
            ])
        }
    }
}
