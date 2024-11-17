//
//  NotificationModel.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct NotificationItem: Identifiable {
    let id: UUID
    let title: String
    let message: String
    let type: NotificationType
    let timestamp: Date
    
    enum NotificationType {
        case tip, scan, community
        
        var icon: String {
            switch self {
            case .tip: return "lightbulb.fill"
            case .scan: return "barcode.viewfinder"
            case .community: return "person.2.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .tip: return .green
            case .scan: return .blue
            case .community: return .orange
            }
        }
    }
}
