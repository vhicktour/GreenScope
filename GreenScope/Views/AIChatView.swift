//
//  AIChatView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct AIChatView: View {
    @State private var input: String = ""
    @State private var chatLog: [ChatMessage] = [
        ChatMessage(id: UUID(), content: "Hello! I am Uriel, your AI assistant. How can I help you today?", isUser: false)
    ]
    private let chatService = ChatService()
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // Chat Log Section
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(chatLog) { message in
                                AIChatBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .onChange(of: chatLog.count) { _ in
                        if let lastMessage = chatLog.last {
                            withAnimation {
                                scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Input Section
                HStack {
                    TextField("Ask a question...", text: $input)
                        .padding(10)
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 1)
                        )
                        .padding(.leading)
                    
                    Button(action: sendQuestion) {
                        Image(systemName: "paperplane.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 5)
                    }
                    .padding(.trailing)
                }
                .padding(.vertical)
                .background(Color(.systemGray6))
                .cornerRadius(20)
            }
            .padding()
        }
        .navigationTitle("AI Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func sendQuestion() {
        guard !input.isEmpty else { return }
        
        let userMessage = ChatMessage(id: UUID(), content: input, isUser: true)
        chatLog.append(userMessage)
        
        let currentInput = input
        input = ""
        
        chatService.fetchAIResponse(for: currentInput) { response in
            DispatchQueue.main.async {
                let aiMessage = ChatMessage(id: UUID(), content: response, isUser: false)
                chatLog.append(aiMessage)
            }
        }
    }
}

// MARK: - AI Chat Bubble View
struct AIChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.green.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
            } else {Text(message.content)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.primary)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                Spacer()
            }
        }
        .padding(.horizontal)
        .transition(.move(edge: message.isUser ? .trailing : .leading))
    }
}

struct AIChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AIChatView()
        }
    }
}
