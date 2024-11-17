//
//  NotificationsView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

// MARK: - Views
struct NotificationRow: View {
    let notification: NotificationItem
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: notification.type.icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(notification.type.color)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(notification.title)
                    .font(.headline)
                
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(notification.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notifications: [NotificationItem] = [
        NotificationItem(id: UUID(), title: "New Eco Tip", message: "Learn about reducing water usage", type: .tip, timestamp: Date()),
        NotificationItem(id: UUID(), title: "Product Scanned", message: "View sustainability report for your recent scan", type: .scan, timestamp: Date().addingTimeInterval(-3600)),
        NotificationItem(id: UUID(), title: "Community Update", message: "New discussion in the community forum", type: .community, timestamp: Date().addingTimeInterval(-7200))
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(notifications) { notification in
                    NotificationRow(notification: notification)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
                                    notifications.remove(at: index)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        withAnimation {
                            notifications.removeAll()
                        }
                    }
                    .disabled(notifications.isEmpty)
                }
            }
            .overlay {
                if notifications.isEmpty {
                    VStack {
                        Image(systemName: "bell.slash")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("You're all caught up!")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

// MARK: - Preview Provider
struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
