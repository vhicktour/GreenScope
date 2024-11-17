//
//  TextFields.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

// MARK: - Custom Text Field
struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}

// MARK: - Custom Secure Field
struct CustomSecureField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    @State private var isSecure = true

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
            
            Button(action: { isSecure.toggle() }) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}
