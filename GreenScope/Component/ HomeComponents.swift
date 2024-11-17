import SwiftUI

// MARK: - SustainabilitySection
struct SustainabilitySection: View {
    let scannedCode: String
    @State private var selectedInsight: Int?

    private let insights: [(title: String, value: String, icon: String)] = [
        ("Carbon Impact", "Low", "leaf.circle"),
        ("Recyclability", "High", "arrow.3.trianglepath"),
        ("Eco Score", "8.5/10", "star.circle"),
        ("Water Usage", "Minimal", "drop.circle"),
        ("Energy Rating", "A+", "bolt.circle")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Sustainability Insights")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.primary)

                    Text(scannedCode != "No code scanned yet" ?
                         "Scanned Product: \(scannedCode)" :
                         "Scan a product to get detailed insights!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if scannedCode != "No code scanned yet" {
                    Button(action: {}) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
            }

            // Insights Cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(insights.indices, id: \.self) { index in
                        InsightCard(
                            title: insights[index].title,
                            value: insights[index].value,
                            icon: insights[index].icon,
                            isSelected: selectedInsight == index
                        )
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedInsight = selectedInsight == index ? nil : index
                            }
                        }
                    }
                }
                .padding(.horizontal, 5)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

// MARK: - InsightCard
struct InsightCard: View {
    let title: String
    let value: String
    let icon: String
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.green)
                .frame(width: 40, height: 40)
                .background(Color.green.opacity(0.1))
                .clipShape(Circle())

            // Title
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            // Value
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .frame(width: 160)
        .padding()
        .background(isSelected ? Color.green.opacity(0.1) : Color(.systemBackground))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.green : Color.gray.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
