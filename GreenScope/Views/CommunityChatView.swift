//
//  CommunityChatView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CommunityChatView: View {
    @State private var message: String = ""
    @State private var messages: [ChatMessage] = []
    @State private var isLoading: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    private let gradientColors = [
        Color(hex: "4CAF50").opacity(0.1),
        Color(hex: "2196F3").opacity(0.05)
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: gradientColors),
                          startPoint: .topLeading,
                          endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Chat header
                ChatHeader()
                
                // Messages ScrollView
                if isLoading {
                    ProgressView("Loading messages...")
                        .padding()
                } else {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(messages) { message in
                                    MessageBubble(message: message)
                                        .id(message.id)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                        }
                        .onChange(of: messages.count) { _ in
                            withAnimation {
                                proxy.scrollTo(messages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Message input area
                MessageInputView(message: $message, onSend: sendMessage)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadMessages()
        }
    }
    
    private func sendMessage() {
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let db = Firestore.firestore()
        let newMessage = ChatMessage(
            id: UUID().uuidString,
            content: message,
            timestamp: Date(),
            senderId: "currentUser", // Replace with actual user ID
            senderName: "You", // Replace with actual user name
            senderAvatar: "https://via.placeholder.com/40" // Replace with actual avatar URL
        )
        
        do {
            try db.collection("messages").document(newMessage.id).setData(from: newMessage)
            message = ""
        } catch {
            print("Error sending message: \(error.localizedDescription)")
        }
    }
    
    private func loadMessages() {
        isLoading = true
        let db = Firestore.firestore()
        db.collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                isLoading = false
                guard let documents = snapshot?.documents else {
                    print("Error fetching messages: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                messages = documents.compactMap { document -> ChatMessage? in
                    try? document.data(as: ChatMessage.self)
                }
            }
    }
}

// MARK: - Supporting Views
struct ChatHeader: View {
    var body: some View {
        VStack {
            HStack {
                Text("Community Chat")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
            .padding()
            
            Divider()
        }
        .background(Color(.systemBackground).opacity(0.8))
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isUser { Spacer() }
            
            if !message.isUser {
                Avatar(url: message.senderAvatar)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 5) {
                if !message.isUser {
                    Text(message.senderName)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(message.content)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(message.isUser ? Color.green : Color(.systemGray6))
                    )
                    .foregroundColor(message.isUser ? .white : .primary)
                
                Text(message.formattedTime)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if message.isUser {
                Avatar(url: message.senderAvatar)
            }
            
            if !message.isUser { Spacer() }
        }
        .padding(.horizontal, 8)
    }
}

struct Avatar: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image.resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
        } placeholder: {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
        }
    }
}

struct MessageInputView: View {
    @Binding var message: String
    let onSend: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                }
                
                TextField("Type a message...", text: $message)
                    .textFieldStyle(.plain)
                    .padding(.vertical, 8)
                    .focused($isFocused)
                
                Button(action: onSend) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.green)
                        .opacity(message.isEmpty ? 0.5 : 1.0)
                }
                .disabled(message.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemBackground).opacity(0.9))
        }
    }
}

// MARK: - Helper Extensions
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct CommunityChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CommunityChatView()
        }
    }
}
