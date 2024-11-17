//
//  ChatService.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import Foundation

class ChatService {
    private let apiUrl = "https://api.openai.com/v1/completions"
    private let apiKey = "YOUR_OPENAI_API_KEY" // Replace with your actual OpenAI API key
    
    func fetchAIResponse(for question: String, maxTokens: Int = 100, completion: @escaping (String) -> Void) {
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            completion("Error: Invalid API URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are Uriel, an AI assistant focused on sustainability and environmental topics."],
                ["role": "user", "content": question]
            ],
            "max_tokens": maxTokens,
            "temperature": 0.7
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Failed to serialize request body: \(error.localizedDescription)")
            completion("Error: Failed to create request")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion("Error: Failed to fetch response")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid HTTP response")
                completion("Error: Invalid response from server")
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion("Error: No data received from server")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(content)
                } else {
                    completion("Error: Invalid response format")
                }
            } catch {
                print("Failed to decode response: \(error.localizedDescription)")
                completion("Error: Failed to decode server response")
            }
        }.resume()
    }
}

// MARK: - OpenAI Response Models
struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let role: String
    let content: String
}
