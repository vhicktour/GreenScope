//
//  ChatMessage.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    let id: String
    let content: String
    let timestamp: Date
    let senderId: String
    let senderName: String
    let senderAvatar: String
    
    var isUser: Bool {
        senderId == "currentUser" // Replace with actual user ID check
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    // Convenience initializer for AI Chat
    init(id: UUID, content: String, isUser: Bool) {
        self.id = id.uuidString
        self.content = content
        self.timestamp = Date()
        self.senderId = isUser ? "currentUser" : "ai-assistant"
        self.senderName = isUser ? "You" : "AI Assistant"
        self.senderAvatar = isUser ? "user-avatar" : "ai-avatar"
    }
    
    // Full initializer for Community Chat
    init(id: String, content: String, timestamp: Date, senderId: String, senderName: String, senderAvatar: String) {
        self.id = id
        self.content = content
        self.timestamp = timestamp
        self.senderId = senderId
        self.senderName = senderName
        self.senderAvatar = senderAvatar
    }
}
