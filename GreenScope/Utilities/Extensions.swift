//
//  Extensions.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

extension View {
    func customCardStyle() -> some View {
        self
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

extension String {
    func truncate(to length: Int) -> String {
        return self.count > length ? String(self.prefix(length)) + "..." : self
    }
}

extension Date {
    func formattedDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
