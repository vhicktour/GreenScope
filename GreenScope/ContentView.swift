//
//  ContentView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/15/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var authState = AuthStateManager()
    
    var body: some View {
        Group {
            if authState.isAuthenticated {
                HomeView()
            } else {
                AuthenticationView()
            }
        }
        .animation(.easeInOut, value: authState.isAuthenticated)
    }
}

class AuthStateManager: ObservableObject {
    @Published var isAuthenticated = false
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
