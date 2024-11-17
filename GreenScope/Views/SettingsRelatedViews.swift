//
//  SettingsRelatedViews.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct ProfileEditView: View {
    var body: some View {
        Text("Profile Edit View")
            .navigationTitle("Edit Profile")
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy")
                        .font(.title.bold())
                    
                    Text("""
                        At GreenScope, we take your privacy seriously. This privacy policy describes how we collect, use, and protect your personal information.
                        
                        Information We Collect:
                        - Product scanning history
                        - Environmental impact preferences
                        - Usage statistics
                        - Device information
                        
                        How We Use Your Information:
                        - Improve product recommendations
                        - Personalize your experience
                        - Analyze app usage patterns
                        - Send relevant notifications
                        
                        Data Protection:
                        We implement industry-standard security measures to protect your data.
                        """)
                        .padding(.vertical)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Terms of Service")
                        .font(.title.bold())
                    
                    Text("""
                        Welcome to GreenScope. By using our app, you agree to these terms.
                        
                        1. Acceptance of Terms
                        By accessing or using GreenScope, you agree to be bound by these terms.
                        
                        2. User Responsibilities
                        - Provide accurate information
                        - Maintain account security
                        - Comply with applicable laws
                        
                        3. App Usage
                        - For personal, non-commercial use
                        - Do not misuse or exploit the service
                        - Report any issues or violations
                        
                        4. Content Guidelines
                        - Share appropriate content
                        - Respect intellectual property rights
                        - Follow community guidelines
                        """)
                        .padding(.vertical)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}
