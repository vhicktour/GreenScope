//
//  QuickActionCard.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//
import SwiftUI

struct QuickActionCard: View {
    let title: String
    let icon: String
    let gradientColors: [Color]
    let width: CGFloat
    var action: () -> Void
    
    @State private var isPressed: Bool = false
    @State private var isHovered: Bool = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            ZStack {
                // Background with glass effect
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white.opacity(0.1))
                            .blur(radius: 5)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.white.opacity(0.6), .clear]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: gradientColors[0].opacity(0.4),
                        radius: isHovered ? 12 : 8,
                        x: 0,
                        y: isPressed ? 4 : 6
                    )
                
                // Content
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [Color.white.opacity(0.3), .clear]),
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 30
                                )
                            )
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.8)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                    }
                    
                    Text(title)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .padding(.horizontal, 6)
                }
                .padding()
            }
            .frame(width: width, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .scaleEffect(isPressed ? 0.96 : isHovered ? 1.03 : 1)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.3)) {
                    isHovered = hovering
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
