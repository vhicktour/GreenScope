//
//  SustainabilityView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct SustainabilityView: View {
    var sustainabilityDetails: String = """
    This product has been designed with a low carbon footprint and can be fully recycled. \
    Its materials are sourced responsibly, and it adheres to eco-friendly production practices.
    """

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Sustainability Analysis")
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)

                Text(sustainabilityDetails)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding()

                Spacer()
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
        .navigationTitle("Sustainability")
    }
}

struct SustainabilityView_Previews: PreviewProvider {
    static var previews: some View {
        SustainabilityView()
    }
}
