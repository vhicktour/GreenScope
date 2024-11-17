//
//  HeroBannerView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct HeroBannerView: View {
    @Binding var heroImageScale: CGFloat
    @AppStorage("userName") private var userName: String = "Guest"
    @State private var gradientPosition: CGFloat = 0
    @State private var pulseEffect = false
    @State private var leafRotation: Double = 0
    @State private var shimmerOffset: CGFloat = -0.7
    @State private var particleSystem = ParticleSystem(count: 100)
    @State private var isHovering = false
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    let primaryGreen = Color(hex: "43A047")
    let secondaryGreen = Color(hex: "8BC34A")
    let accentGreen = Color(hex: "2E7D32")
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            primaryGreen,
                            secondaryGreen,
                            accentGreen
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    ForEach(0..<3) { index in
                        WaveShape(frequency: Double(index + 1) * 0.5)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        secondaryGreen.opacity(0.3),
                                        accentGreen.opacity(0.1)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: geometry.size.height * 0.8)
                            .offset(x: CGFloat(index) * 50)
                            .animation(
                                Animation.easeInOut(duration: Double(index + 1) * 2)
                                    .repeatForever(autoreverses: true),
                                value: gradientPosition
                            )
                    }
                    
                    ParticleView(system: particleSystem)
                }
            }
            .hueRotation(Angle(degrees: gradientPosition))
            .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: gradientPosition)
            .edgesIgnoringSafeArea(.all)
            
            ForEach(0..<20) { index in
                FloatingLeaf(index: index, rotation: leafRotation)
            }
            
            VStack(spacing: 25) {
                VStack(spacing: 12) {
                    Text("Hello, \(userName)!")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.white, .white.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .white.opacity(0.5), radius: 15, x: 0, y: 0)
                        .modifier(ShimmerEffect(offset: shimmerOffset))
                    
                    Text("Together, we make Earth greener.")
                        .font(.title3)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.white.opacity(0.9), .white.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .white.opacity(0.3), radius: 8, x: 0, y: 0)
                }
                .scaleEffect(pulseEffect ? 1.05 : 1)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulseEffect)
                
                HStack(spacing: 20) {
                    EcoStat(
                        value: "12",
                        title: "Products\nScanned",
                        icon: "barcode.viewfinder",
                        isHighlighted: true,
                        animation: Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5)
                    )
                    EcoStat(
                        value: "92%",
                        title: "Eco\nScore",
                        icon: "leaf.fill",
                        isHighlighted: false,
                        animation: Animation.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.6)
                    )
                    EcoStat(
                        value: "7",
                                                title: "Eco\nBadges",
                                                icon: "sparkles",
                                                isHighlighted: true,
                                                animation: Animation.spring(response: 0.7, dampingFraction: 0.4, blendDuration: 0.7)
                                            )
                                        }
                                        .padding(.vertical, 15)
                                        .background(
                                            GlassBackground()
                                        )
                                        .padding(.horizontal)
                                    }
                                    .padding()
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.white.opacity(0.5), .clear],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(color: accentGreen.opacity(0.4), radius: 20, x: 0, y: 15)
                                .scaleEffect(heroImageScale)
                                .onAppear {
                                    withAnimation {
                                        gradientPosition = 360
                                        pulseEffect = true
                                    }
                                    withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                                        shimmerOffset = 1.7
                                    }
                                }
                                .onReceive(timer) { _ in
                                    withAnimation(.easeInOut(duration: 8)) {
                                        leafRotation += 45
                                    }
                                    particleSystem.update()
                                }
                            }
                        }

                        // MARK: - View-Specific Components

                        struct FloatingLeaf: View {
                            let index: Int
                            let rotation: Double
                            @State private var offset: CGPoint = .zero
                            @State private var scale: CGFloat = 1
                            
                            var body: some View {
                                Image(systemName: "leaf.fill")
                                    .resizable()
                                    .frame(width: CGFloat.random(in: 40...80), height: CGFloat.random(in: 40...80))
                                    .foregroundColor(.white.opacity(0.2))
                                    .rotationEffect(Angle(degrees: rotation + Double(index * 24)))
                                    .offset(x: offset.x, y: offset.y)
                                    .scaleEffect(scale)
                                    .onAppear {
                                        offset = CGPoint(
                                            x: CGFloat.random(in: -200...200),
                                            y: CGFloat.random(in: -400...400)
                                        )
                                        withAnimation(
                                            Animation
                                                .easeInOut(duration: Double.random(in: 4...7))
                                                .repeatForever(autoreverses: true)
                                        ) {
                                            offset = CGPoint(
                                                x: CGFloat.random(in: -200...200),
                                                y: CGFloat.random(in: -400...400)
                                            )
                                            scale = CGFloat.random(in: 0.8...1.2)
                                        }
                                    }
                            }
                        }

                        struct WaveShape: Shape {
                            let frequency: Double
                            
                            func path(in rect: CGRect) -> Path {
                                var path = Path()
                                let width = rect.width
                                let height = rect.height
                                let midHeight = height / 2
                                
                                path.move(to: CGPoint(x: 0, y: midHeight))
                                
                                for x in stride(from: 0, through: width, by: 1) {
                                    let relativeX = x / width
                                    let y = midHeight + sin(relativeX * .pi * frequency) * (height / 4)
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                                
                                path.addLine(to: CGPoint(x: width, y: height))
                                path.addLine(to: CGPoint(x: 0, y: height))
                                path.closeSubpath()
                                
                                return path
                            }
                        }

                        struct EcoStat: View {
                            let value: String
                            let title: String
                            let icon: String
                            let isHighlighted: Bool
                            let animation: Animation
                            @State private var isAnimating = false
                            
                            var body: some View {
                                VStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                RadialGradient(
                                                    gradient: Gradient(colors: [
                                                        Color(hex: "8BC34A").opacity(0.3),
                                                        Color(hex: "8BC34A").opacity(0)
                                                    ]),
                                                    center: .center,
                                                    startRadius: 0,
                                                    endRadius: 25
                                                )
                                            )
                                            .frame(width: 50, height: 50)
                                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                                        
                                        Image(systemName: icon)
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [
                                                        isHighlighted ? Color(hex: "8BC34A") : .white,
                                                        isHighlighted ? Color(hex: "8BC34A").opacity(0.7) : .white.opacity(0.7)
                                                    ],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                                    }
                                    .rotation3DEffect(
                                        .degrees(isAnimating ? 360 : 0),
                                        axis: (x: 0, y: 1, z: 0)
                                    )
                                    
                                    Text(value)
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                                    
                                    Text(title)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(.ultraThinMaterial)
                                        
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        .white.opacity(0.6),
                                                        .white.opacity(0.2)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    }
                                )
                                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                .onAppear {
                                    withAnimation(animation.repeatForever(autoreverses: true)) {
                                        isAnimating = true
                                    }
                                }
                            }
                        }
