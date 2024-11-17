//
//  ParticleSystem.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//


import SwiftUI

// MARK: - Particle System
struct ParticleSystem {
    var particles: [Particle]
    
    init(count: Int) {
        particles = (0..<count).map { _ in Particle() }
    }
    
    mutating func update() {
        for index in particles.indices {
            particles[index].update()
        }
    }
}

struct Particle {
    var position = CGPoint(x: Double.random(in: -1...1), y: Double.random(in: -1...1))
    var speed = Double.random(in: 0.3...1.5)
    var scale = Double.random(in: 0.2...0.5)
    var opacity = Double.random(in: 0.1...0.5)
    
    mutating func update() {
        position.y += speed / 100
        if position.y > 1 {
            position.y = -1
            position.x = Double.random(in: -1...1)
            opacity = Double.random(in: 0.1...0.5)
        }
    }
}

struct ParticleView: View {
    let system: ParticleSystem
    
    var body: some View {
        Canvas { context, size in
            for particle in system.particles {
                let xPos = particle.position.x * size.width
                let yPos = particle.position.y * size.height
                
                context.opacity = particle.opacity
                context.fill(
                    Circle().path(in: CGRect(
                        x: xPos,
                        y: yPos,
                        width: 3 * particle.scale,
                        height: 3 * particle.scale
                    )),
                    with: .color(.white)
                )
            }
        }
    }
}

// MARK: - Shared Modifiers and Effects
struct ShimmerEffect: ViewModifier {
    let offset: CGFloat
    
    func body(content: Content) -> some View {
        content.overlay(
            LinearGradient(
                gradient: Gradient(colors: [
                    .clear,
                    .white.opacity(0.5),
                    .clear
                ]),
                startPoint: UnitPoint(x: offset, y: offset),
                endPoint: UnitPoint(x: 1 + offset, y: 1 + offset)
            )
            .mask(content)
        )
    }
}

struct GlassBackground: View {
    let cornerRadius: CGFloat
    let strokeGradient: Bool
    
    init(cornerRadius: CGFloat = 20, strokeGradient: Bool = true) {
        self.cornerRadius = cornerRadius
        self.strokeGradient = strokeGradient
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(.ultraThinMaterial)
            .overlay(
                Group {
                    if strokeGradient {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.6), .white.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                }
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Animation Constants
enum AnimationConstants {
    static let standardSpring = Animation.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.3)
    static let iconPulse = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    static let shimmer = Animation.linear(duration: 2).repeatForever(autoreverses: false)
    static let rotation = Animation.linear(duration: 20).repeatForever(autoreverses: false)
}
