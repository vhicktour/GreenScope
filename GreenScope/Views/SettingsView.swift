
//
//  SettingsView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("userName") private var userName: String = "Guest"
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("useMetricSystem") private var useMetricSystem = true
    @State private var showingPrivacyPolicy = false
    @State private var showingTerms = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    TextField("Name", text: $userName)
                    NavigationLink("Edit Profile") {
                        ProfileEditView()
                    }
                }
                
                Section(header: Text("Preferences")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                    Toggle("Use Metric System", isOn: $useMetricSystem)
                }
                
                Section(header: Text("Data & Privacy")) {
                    Button("Export Data") {
                        // Handle data export
                    }
                    Button("Delete Account", role: .destructive) {
                        // Handle account deletion
                    }
                }
                
                Section(header: Text("App")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Privacy Policy") {
                        showingPrivacyPolicy = true
                    }
                    
                    Button("Terms of Service") {
                        showingTerms = true
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showingTerms) {
                TermsOfServiceView()
            }
        }
    }
}

// MARK: - Preview Provider
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
