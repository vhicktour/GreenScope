
//
//  EcoBackground.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI
import CoreMotion

// MARK: - Leaf Model
struct Leaf: Identifiable {
    let id = UUID()
    var position: CGPoint
    var rotation: Double
    var scale: CGFloat
    var speed: CGFloat
    var horizontalOffset: CGFloat
    
    mutating func updatePosition(in size: CGSize, motion: CMAccelerometerData?) {
        // Update vertical position
        position.y += speed
        
        // Add swaying motion
        position.x = position.x + sin(position.y / 50) * 2
        
        // Add device tilt effect if available
        if let motion = motion {
            position.x += CGFloat(motion.acceleration.x * 2)
        }
        
        // Reset position when leaf goes off screen
        if position.y > size.height + 50 {
            position.y = -50
            position.x = CGFloat.random(in: 0...size.width)
        }
    }
}

// MARK: - Leaf View
struct LeafView: View {
    let leaf: Leaf
    let color: Color
    
    var body: some View {
        Image(systemName: "leaf.fill")
            .font(.system(size: 20 * leaf.scale))
            .foregroundStyle(
                LinearGradient(
                    colors: [color, color.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .rotationEffect(.degrees(leaf.rotation))
            .position(leaf.position)
    }
}

// MARK: - Interactive Background
class LeafAnimationModel: ObservableObject {
    @Published var leaves: [Leaf] = []
    private var motionManager: CMMotionManager
    @Published var accelerometerData: CMAccelerometerData?
    private var timer: Timer?
    
    init(count: Int = 15) {
        motionManager = CMMotionManager()
        createLeaves(count: count)
        startMotionUpdates()
    }
    
    func createLeaves(count: Int) {
        leaves = (0..<count).map { _ in
            Leaf(
                position: CGPoint(
                    x: CGFloat.random(in: -50...UIScreen.main.bounds.width + 50),
                    y: CGFloat.random(in: -200...UIScreen.main.bounds.height)
                ),
                rotation: Double.random(in: 0...360),
                scale: CGFloat.random(in: 0.5...1.5),
                speed: CGFloat.random(in: 1...3),
                horizontalOffset: 0
            )
        }
    }
    
    func startMotionUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1/60
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
                guard error == nil else { return }
                self?.accelerometerData = data
            }
        }
    }
    
    func updateLeaves(in size: CGSize) {
        for i in leaves.indices {
            leaves[i].updatePosition(in: size, motion: accelerometerData)
        }
    }
    
    func addLeafAtPoint(_ point: CGPoint) {
        let newLeaf = Leaf(
            position: point,
            rotation: Double.random(in: 0...360),
            scale: CGFloat.random(in: 0.5...1.5),
            speed: CGFloat.random(in: 1...3),
            horizontalOffset: 0
        )
        leaves.append(newLeaf)
        
        // Remove oldest leaf if there are too many
        if leaves.count > 30 {
            leaves.removeFirst()
        }
    }
}

// MARK: - Interactive Eco Background
struct InteractiveEcoBackground: View {
    @StateObject private var leafModel = LeafAnimationModel()
    let gradientColors: [Color]
    @GestureState private var dragLocation: CGPoint?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base gradient
                LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(0.7)
                
                // Falling leaves
                ForEach(leafModel.leaves) { leaf in
                    LeafView(
                        leaf: leaf,
                        color: Color(hex: "4CAF50").opacity(0.3)
                    )
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($dragLocation) { value, state, _ in
                        state = value.location
                        leafModel.addLeafAtPoint(value.location)
                    }
            )
            .onAppear {
                // Start leaf animation timer
                Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
                    leafModel.updateLeaves(in: geometry.size)
                }
            }
        }
        .ignoresSafeArea()
    }
}
