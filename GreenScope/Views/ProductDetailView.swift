//
//  ProductDetailView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct ProductDetailView: View {
    let productName: String
    let sustainabilityScore: Double
    let recyclability: String
    let environmentalImpact: String
    let healthEffects: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                Text(productName)
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.green)
                    .multilineTextAlignment(.leading)

                SustainabilityGauge(score: sustainabilityScore)

                // Details Section
                VStack(alignment: .leading, spacing: 15) {
                    DetailCard(title: "Recyclability", description: recyclability, icon: "recycle")
                    DetailCard(title: "Environmental Impact", description: environmentalImpact, icon: "leaf.fill")
                    DetailCard(title: "Health Effects", description: healthEffects, icon: "heart.fill")
                }
            }
            .padding()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - Gauge View
struct SustainabilityGauge: View {
    let score: Double

    var body: some View {
        VStack {
            Text("Sustainability Score")
                .font(.headline)
                .foregroundColor(.primary)

            ZStack {
                Circle()
                    .stroke(Color.green.opacity(0.3), lineWidth: 20)
                Circle()
                    .trim(from: 0, to: CGFloat(score / 10))
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text("\(Int(score * 10))%")
                    .font(.title)
                    .bold()
                    .foregroundColor(.green)
            }
            .frame(width: 150, height: 150)
        }
        .padding()
    }
}

// MARK: - Detail Card
struct DetailCard: View {
    let title: String
    let description: String
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.green)
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.green.opacity(0.2)))

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(
            productName: "Eco-Friendly Bottle",
            sustainabilityScore: 8.7,
            recyclability: "Fully recyclable material.",
            environmentalImpact: "Low carbon footprint during production.",
            healthEffects: "No harmful chemicals detected."
        )
    }
}
