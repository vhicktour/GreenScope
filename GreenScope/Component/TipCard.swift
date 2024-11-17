//
//  TipCard.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//


// Components/TipCard.swift
import SwiftUI

struct TipCard: View {
    let tip: String
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "leaf.fill")
                .foregroundColor(.green)
                .font(.title2)
            
            Text(tip)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
        .background(isSelected ? Color.green.opacity(0.1) : Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.green : Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
