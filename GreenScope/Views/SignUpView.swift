//
//  SignUpView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var name = ""
    @State private var headerGlow = false
    @State private var backgroundOffset: CGFloat = 0
    @State private var formOpacity: Double = 0
    
    private let gradientColors = [
        Color(hex: "8FBF9F"),  // Soft sage green
        Color(hex: "AECFBA"),  // Light forest green
        Color(hex: "D3E4CD")   // Pale mint
    ]
    
    init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated eco-friendly background
                backgroundLayer
                
                ScrollView {
                    VStack(spacing: 35) {
                        // Welcome Header
                        headerSection
                            .padding(.top, 40)
                        
                        // Enhanced Sign Up Form
                        formSection
                            .padding(.horizontal)
                        
                        // Sign In Option
                        signInButton
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
        }
    }
    
    private var backgroundLayer: some View {// leaf droping
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
        VStack(spacing: 20) {
            // Eco-friendly icon
            ZStack {
                Image(systemName: "person.crop.circle.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(.green.opacity(0.3))
                    .blur(radius: headerGlow ? 20 : 10)
                
                Image(systemName: "person.crop.circle.badge.plus")
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
                    .shadow(color: .green.opacity(0.5), radius: headerGlow ? 15 : 5)
                    .scaleEffect(headerGlow ? 1.05 : 1.0)
            }
            
            VStack(spacing: 12) {
                Text("Create Account")
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
                
                Text("Join the eco-friendly community")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .opacity(headerGlow ? 1 : 0.8)
        .animation(.easeIn(duration: 0.5), value: headerGlow)
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            Group {
                CustomTextField(
                    text: $name,
                    placeholder: "Full Name",
                    icon: "person.fill"
                )
                .transition(.move(edge: .leading))
                
                CustomTextField(
                    text: $viewModel.email,
                    placeholder: "Email",
                    icon: "envelope.fill"
                )
                .transition(.move(edge: .trailing))
                
                CustomSecureField(
                    text: $viewModel.password,
                    placeholder: "Password",
                    icon: "lock.fill"
                )
                .transition(.move(edge: .leading))
                
                CustomSecureField(
                    text: $viewModel.confirmPassword,
                    placeholder: "Confirm Password",
                    icon: "lock.fill"
                )
                .transition(.move(edge: .trailing))
            }
            .opacity(formOpacity)
            
            Button(action: {
                viewModel.signUp()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Create Account")
                        .fontWeight(.semibold)
                }
            }
            .buttonStyle(EcoButtonStyle(type: .primary))
            .disabled(viewModel.isLoading)
            .opacity(formOpacity)
        }
    }
    
    private var signInButton: some View {
        Button("Already have an account? Sign In") {
            dismiss()
        }
        .buttonStyle(EcoButtonStyle(type: .tertiary))
        .opacity(formOpacity)
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1)) {
            headerGlow = true
        }
        
        withAnimation(.easeInOut(duration: 0.6).delay(0.3)) {
            formOpacity = 1
        }
        
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            backgroundOffset = 2 * .pi
        }
    }
}

// MARK: - Preview Provider
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: AuthenticationViewModel())
    }
}
