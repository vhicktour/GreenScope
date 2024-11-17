
//
//  SplashScreen.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "43A047"), Color(hex: "1E88E5")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(0.2)
                .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "leaf.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                    
                    Text("GreenScope")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}
