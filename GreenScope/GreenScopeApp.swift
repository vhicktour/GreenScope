//
//  GreenScopeApp.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/15/24.
//

import SwiftUI
import Firebase

@main
struct GreenScopeApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
}
