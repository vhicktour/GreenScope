//
//  TipsSection.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//


import SwiftUI

struct TipsSection: View {
    let tips: [String]
    @Binding var showTips: Bool
    @Binding var currentTipIndex: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Daily Eco Tips")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showTips.toggle()
                    }
                }) {
                    Image(systemName: showTips ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            
            if showTips {
                TabView(selection: $currentTipIndex) {
                    ForEach(0..<tips.count, id: \.self) { index in
                        TipCard(tip: tips[index], isSelected: currentTipIndex == index)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 150)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}
