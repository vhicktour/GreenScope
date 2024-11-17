//
//  ProfileView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var userName: String = "Victor Udeh"
    @State private var scannedHistory: [String] = [
        "Eco-Friendly Bottle",
        "Reusable Coffee Cup",
        "Biodegradable Plates"
    ]
    @State private var showSettings: Bool = false
    @State private var animateAvatar: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Profile Header
                profileHeader
                
                // Scanned History Section
                scannedHistorySection
                
                // Settings Button
                settingsButton
            }
            .padding()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        )
        .navigationTitle("Your Profile")
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }

    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 120, height: 120)
                    .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)

                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(animateAvatar ? 15 : -15))
                    .onAppear {
                        withAnimation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                        ) {
                            animateAvatar.toggle()
                        }
                    }
            }

            Text(userName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text("Eco-Warrior Level 5 🌿")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding()
    }

    // MARK: - Scanned History Section
    private var scannedHistorySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Scanned History")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.primary)

                Spacer()

                Button(action: clearHistory) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Clear All")
                    }
                    .font(.footnote)
                    .foregroundColor(.red)
                }
            }

            if scannedHistory.isEmpty {
                Text("No products scanned yet.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(scannedHistory, id: \.self) { product in
                            scannedHistoryCard(product: product)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Scanned History Card
    private func scannedHistoryCard(product: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: "leaf.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.green)

            Text(product)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .frame(width: 120)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
    }

    // MARK: - Settings Button
    private var settingsButton: some View {
        Button(action: {
            showSettings = true
        }) {
            HStack {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(.white)

                Text("Manage Settings")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(15)
            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.top, 10)
    }

    // MARK: - Clear History Action
    private func clearHistory() {
        withAnimation {
            scannedHistory.removeAll()
        }
    }
}

// MARK: - Settings View (Modal Sheet)
struct ProfileSettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text("Victor Udeh")
                            .foregroundColor(.gray)
                    }
                    NavigationLink(destination: Text("Change Password")) {
                        Text("Change Password")
                    }
                }

                Section(header: Text("Notifications")) {
                    Toggle("Receive Sustainability Tips", isOn: .constant(true))
                    Toggle("Product Scan Reminders", isOn: .constant(false))
                }

                Section(header: Text("App")) {
                    Text("Version 1.0.0")
                    Button("Privacy Policy") {}
                    Button("Terms of Service") {}
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
