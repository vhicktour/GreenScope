//
//  ResetPasswordView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var showSuccessMessage = false
    @State private var iconGlow = false
    @State private var backgroundOffset: CGFloat = 0
    
    private let gradientColors = [
        Color(hex: "8FBF9F"),  // Soft sage green
        Color(hex: "AECFBA"),  // Light forest green
        Color(hex: "D3E4CD")   // Pale mint
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated eco-friendly background
                backgroundLayer
                
                ScrollView {
                    VStack(spacing: 35) {
                        // Enhanced Header
                        headerSection
                            .padding(.top, 40)
                        
                        // Email Field with animation
                        emailSection
                            .padding(.horizontal)
                        
                        // Action Buttons
                        buttonSection
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
            }
            .onAppear(perform: startAnimations)
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .alert("Success", isPresented: $showSuccessMessage) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("Password reset link has been sent to your email.")
            }
        }
    }
    
    private var backgroundLayer: some View {// leaf dropping
        ZStack {
            InteractiveEcoBackground(gradientColors: gradientColors)
            
            // Your existing overlay circles can remain
            GeometryReader { proxy in
                ForEach(0..<3) { index in
                    Circle()
                        .fill(gradientColors[index].opacity(0.1))
                        .frame(width: proxy.size.width * 0.8)
                        .offset(
                            x: CGFloat.random(in: -100...100) + sin(backgroundOffset + Double(index)) * 5,
                            y: CGFloat.random(in: -100...100) + cos(backgroundOffset + Double(index)) * 5
                        )
                        .blur(radius: 50)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 25) {
            // Enhanced icon with glow effect
            ZStack {
                // Outer glow
                Image(systemName: "lock.rotation")
                    .font(.system(size: 60))
                    .foregroundColor(.green.opacity(0.3))
                    .blur(radius: iconGlow ? 20 : 10)
                
                // Main icon
                Image(systemName: "lock.rotation")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(hex: "4CAF50"),
                                Color(hex: "81C784")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .green.opacity(0.5), radius: iconGlow ? 15 : 5)
                    .scaleEffect(iconGlow ? 1.05 : 1.0)
            }
            
            VStack(spacing: 12) {
                Text("Reset Password")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(hex: "2E7D32"),
                                Color(hex: "388E3C")
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Enter your email to receive a password reset link")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .opacity(iconGlow ? 1 : 0.8)
        .animation(.easeIn(duration: 0.5), value: iconGlow)
    }
    
    private var emailSection: some View {
        CustomTextField(
            text: $viewModel.email,
            placeholder: "Email",
            icon: "envelope.fill"
        )
        .transition(.move(edge: .leading))
    }
    
    private var buttonSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                viewModel.resetPassword()
                showSuccessMessage = true
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Send Reset Link")
                        .fontWeight(.semibold)
                }
            }
            .buttonStyle(EcoButtonStyle(type: .primary))
            .disabled(viewModel.isLoading)
            
            Button("Back to Sign In") {
                dismiss()
            }
            .buttonStyle(EcoButtonStyle(type: .tertiary))
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1)) {
            iconGlow = true
        }
        
        // Continuous subtle background animation
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            backgroundOffset = 2 * .pi
        }
    }
}
