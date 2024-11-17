//
//  AuthenticationService.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import Foundation
import FirebaseAuth

class AuthenticationService {
    static let shared = AuthenticationService()
    private init() {}
    
    // MARK: - User State
    @Published var currentUser: User?
    
    // MARK: - Sign In
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }
            
            self?.currentUser = user
            completion(.success(user))
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create user"])))
                return
            }
            
            self?.currentUser = user
            completion(.success(user))
        }
    }
    
    // MARK: - Sign Out
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    // MARK: - Check Authentication State
    func checkAuthState() -> Bool {
        return Auth.auth().currentUser != nil
    }
}

