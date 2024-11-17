//
//  AuthenticationView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var showingSignUp = false
    @State private var showingResetPassword = false
    @State private var logoGlow: Bool = false
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
                        // Enhanced logo section
                        LogoSection(glow: $logoGlow)
                            .padding(.top, 40)
                        
                        // Sign In Form with enhanced styling
                        SignInForm(
                            email: $viewModel.email,
                            password: $viewModel.password,
                            isLoading: viewModel.isLoading,
                            onSubmit: viewModel.signIn
                        )
                        .padding(.horizontal)
                        .transition(.scale)
                        
                        // Refined divider
                        dividerSection
                        
                        // Enhanced additional options
                        actionButtons
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .onAppear(perform: startAnimations)
            .sheet(isPresented: $showingSignUp) {
                SignUpView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingResetPassword) {
                ResetPasswordView(viewModel: viewModel)
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
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
    
    private var dividerSection: some View {
        HStack {
            VStack(spacing: 0) {
                Capsule()
                    .frame(height: 1)
                    .foregroundColor(.primary.opacity(0.2))
            }
            
            Text("or continue with")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
            
            VStack(spacing: 0) {
                Capsule()
                    .frame(height: 1)
                    .foregroundColor(.primary.opacity(0.2))
            }
        }
        .padding(.vertical)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button("Create Account") {
                showingSignUp = true
            }
            .buttonStyle(EcoButtonStyle(type: .secondary))
            
            Button("Reset Password") {
                showingResetPassword = true
            }
            .buttonStyle(EcoButtonStyle(type: .tertiary))
        }
        .padding(.top, 10)
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1)) {
            logoGlow = true
        }
        
        // Continuous subtle background animation
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            backgroundOffset = 2 * .pi
        }
    }
}

// MARK: - Supporting Views

struct LogoSection: View {
    @Binding var glow: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Enhanced eco-friendly logo
            ZStack {
                // Outer glow
                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 110))
                    .foregroundColor(.green.opacity(0.3))
                    .blur(radius: glow ? 20 : 10)
                
                // Main logo
                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 100))
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
                    .shadow(color: .green.opacity(0.5), radius: glow ? 15 : 5)
                    .scaleEffect(glow ? 1.05 : 1.0)
                    .animation(
                        .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: glow
                    )
            }
            
            VStack(spacing: 12) {
                Text("Welcome to GreenScope")
                    .font(.title.weight(.bold))
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
                
                Text("Your Journey to Sustainable Living")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .opacity(glow ? 1 : 0.8)
            .animation(.easeIn(duration: 0.5), value: glow)
        }
    }
}

struct SignInForm: View {
    @Binding var email: String
    @Binding var password: String
    var isLoading: Bool
    var onSubmit: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(
                text: $email,
                placeholder: "Email",
                icon: "envelope.fill"
            )
            .transition(.move(edge: .leading))
            
            CustomSecureField(
                text: $password,
                placeholder: "Password",
                icon: "lock.fill"
            )
            .transition(.move(edge: .trailing))
            
            Button(action: onSubmit) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign In")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 20)
                }
            }
            .buttonStyle(EcoButtonStyle(type: .primary))
            .disabled(isLoading)
        }
    }
}

// MARK: - Custom Styles
struct EcoButtonStyle: ButtonStyle {
    enum ButtonType {
        case primary, secondary, tertiary
    }
    
    let type: ButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundGradient)
            .foregroundColor(foregroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(strokeColor, lineWidth: type == .tertiary ? 1 : 0)
            )
            .shadow(
                color: shadowColor,
                radius: configuration.isPressed ? 2 : 5,
                x: 0,
                y: configuration.isPressed ? 1 : 3
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
    
    private var backgroundGradient: LinearGradient {
        switch type {
        case .primary:
            return LinearGradient(
                colors: [Color(hex: "4CAF50"), Color(hex: "388E3C")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .secondary:
            return LinearGradient(
                colors: [Color(hex: "81C784"), Color(hex: "66BB6A")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .tertiary:
            return LinearGradient(colors: [.white, .white], startPoint: .top, endPoint: .bottom)
        }
    }
    
    private var foregroundColor: Color {
        switch type {
        case .primary, .secondary:
            return .white
        case .tertiary:
            return Color(hex: "2E7D32")
        }
    }
    
    private var shadowColor: Color {
        switch type {
        case .primary:
            return Color(hex: "388E3C").opacity(0.3)
        case .secondary:
            return Color(hex: "66BB6A").opacity(0.3)
        case .tertiary:
            return Color.black.opacity(0.1)
        }
    }
    
    private var strokeColor: Color {
        switch type {
        case .tertiary:
            return Color(hex: "81C784").opacity(0.5)
        default:
            return .clear
        }
    }
}
