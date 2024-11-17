//
//  HomeView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

// Define navigation destinations
enum NavigationDestination: Hashable {
    case scan
    case profile
    case alternatives
    case communityChat
    case aiChat
    case nearbyCenters
    case faq
}

struct HomeView: View {
    // MARK: - Properties
    @State private var scannedCode: String = "No code scanned yet"
    @State private var showTips: Bool = false
    @State private var currentTipIndex: Int = 0
    @State private var heroImageScale: CGFloat = 1.0
    @State private var quickActionOpacity: Double = 0.0
    @State private var sustainabilityOffset: CGFloat = 100
    @State private var showSignOut = false
    @State private var showSettings = false
    @State private var showNotifications = false
    @State private var navigationPath = NavigationPath()
    @StateObject private var authViewModel = AuthenticationViewModel()
    private let authService = AuthenticationService.shared

    private let tips = [
        "Reduce Plastic Usage: Opt for reusable bags and water bottles to minimize plastic waste.",
        "Recycle Correctly: Check local recycling guidelines to avoid contamination.",
        "Buy in Bulk: Buying in bulk reduces packaging waste and saves money.",
        "Use Public Transport: Reduce your carbon footprint by using public transportation.",
        "Save Energy: Turn off lights and unplug devices when not in use."
    ]

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                ZStack {
                    // Background Gradient
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "43A047").opacity(0.3),
                            Color(hex: "1E88E5").opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)

                    ScrollView {
                        VStack(spacing: 30) {
                            // Hero Section
                            HeroBannerView(heroImageScale: $heroImageScale)
                                .transition(.move(edge: .top))

                            // Quick Actions Grid
                            LazyVGrid(
                                columns: [GridItem(.adaptive(minimum: 150), spacing: 20)],
                                spacing: 20
                            ) {
                                // Scan Product
                                QuickActionCard(
                                    title: "Scan Product",
                                    icon: "barcode.viewfinder",
                                    gradientColors: [Color(hex: "43A047"), Color(hex: "2E7D32")],
                                    width: (geometry.size.width / 2) - 30
                                ) {
                                    navigationPath.append(NavigationDestination.scan)
                                }

                                // Profile
                                QuickActionCard(
                                    title: "Your Profile",
                                    icon: "person.crop.circle",
                                    gradientColors: [Color(hex: "1E88E5"), Color(hex: "1565C0")],
                                    width: (geometry.size.width / 2) - 30
                                ) {
                                    navigationPath.append(NavigationDestination.profile)
                                }

                                // Eco Alternatives
                                QuickActionCard(
                                    title: "Eco Alternatives",
                                    icon: "leaf.circle.fill",
                                    gradientColors: [Color(hex: "4CAF50"), Color(hex: "2E7D32")],
                                    width: (geometry.size.width / 2) - 30
                                ) {
                                    navigationPath.append(NavigationDestination.alternatives)
                                }

                                // Community Chat
                                QuickActionCard(
                                    title: "Community Chat",
                                    icon: "message.fill",
                                    gradientColors: [Color(hex: "FF7043"), Color(hex: "E64A19")],
                                    width: (geometry.size.width / 2) - 30
                                ) {
                                    navigationPath.append(NavigationDestination.communityChat)
                                }

                                // AI Chat
                                QuickActionCard(
                                    title: "AI Assistant",
                                    icon: "sparkles.square.filled.on.square",
                                    gradientColors: [Color(hex: "7E57C2"), Color(hex: "4527A0")],
                                    width: (geometry.size.width / 2) - 30
                                ) {
                                    navigationPath.append(NavigationDestination.aiChat)
                                }

                                // Nearby Centers
                                QuickActionCard(
                                    title: "Nearby Centers",
                                    icon: "mappin.circle.fill",
                                    gradientColors: [Color(hex: "26A69A"), Color(hex: "00796B")],
                                    width: (geometry.size.width / 2) - 30
                                ) {
                                    navigationPath.append(NavigationDestination.nearbyCenters)
                                }

                                // FAQ
                                QuickActionCard(
                                    title: "FAQ & Help",
                                    icon: "questionmark.circle.fill",
                                    gradientColors: [Color(hex: "78909C"), Color(hex: "455A64")],
                                    width: (geometry.size.width / 2) - 30
                                ) {
                                    navigationPath.append(NavigationDestination.faq)
                                }
                            }
                            .opacity(quickActionOpacity)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.2)) {
                                    quickActionOpacity = 1.0
                                }
                            }

                            // Sustainability Section
                            SustainabilitySection(scannedCode: scannedCode)
                                .offset(y: sustainabilityOffset)
                                .onAppear {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        sustainabilityOffset = 0
                                    }
                                }

                            // Tips Section
                            TipsSection(tips: tips, showTips: $showTips, currentTipIndex: $currentTipIndex)
                        }
                        .padding()
                    }
                }
                .navigationTitle("GreenScope")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 15) {
                            // Notifications Button
                            Button(action: { showNotifications.toggle() }) {
                                Image(systemName: "bell.fill")
                                    .foregroundColor(.primary)
                                    .overlay(
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 8, height: 8)
                                            .offset(x: 10, y: -10)
                                            .opacity(0.8)
                                    )
                            }

                            // Settings Menu
                            Menu {
                                Button(action: { showSettings = true }) {
                                    Label("Settings", systemImage: "gear")
                                }

                                Button(action: {}) {
                                    Label("Help", systemImage: "questionmark.circle")
                                }

                                Divider()

                                Button(role: .destructive, action: { showSignOut = true }) {
                                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .scan:
                        ScanView(scannedCode: $scannedCode) {
                            print("Scan complete: \(scannedCode)")
                        }
                    case .profile:
                        ProfileView()
                    case .alternatives:
                        AlternativesView(alternatives: [])
                    case .communityChat:
                        CommunityChatView()
                    case .aiChat:
                        AIChatView()
                    case .nearbyCenters:
                        NearbyEcoView()
                    case .faq:
                        FAQView()
                    }
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
                .sheet(isPresented: $showNotifications) {
                    NotificationsView()
                }
                .alert("Sign Out", isPresented: $showSignOut) {
                    Button("Cancel", role: .cancel) { }
                    Button("Sign Out", role: .destructive) {
                        authService.signOut { _ in }
                    }
                } message: {
                    Text("Are you sure you want to sign out?")
                }
            }
        }
    }
}
