//
//  AuthenticationViewModel.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import Foundation
import Combine
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var navigateToHome = false
    
    private let authService = AuthenticationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Sign In
    func signIn() {
        guard validateInput() else { return }
        
        isLoading = true
        authService.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.navigateToHome = true
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp() {
        guard validateSignUpInput() else { return }
        
        isLoading = true
        authService.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.navigateToHome = true
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    
    // MARK: - Reset Password
    func resetPassword() {
        guard validateEmail() else { return }
        
        isLoading = true
        authService.resetPassword(email: email) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    // Handle successful password reset
                    break
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Validation
    private func validateInput() -> Bool {
        guard validateEmail() else { return false }
        guard !password.isEmpty else {
            showError = true
            errorMessage = "Please enter your password"
            return false
        }
        return true
    }
    
    private func validateSignUpInput() -> Bool {
        guard validateInput() else { return false }
        guard password == confirmPassword else {
            showError = true
            errorMessage = "Passwords do not match"
            return false
        }
        return true
    }
    
    private func validateEmail() -> Bool {
        guard !email.isEmpty else {
            showError = true
            errorMessage = "Please enter your email"
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
            showError = true
            errorMessage = "Please enter a valid email"
            return false
        }
        
        return true
    }
}
