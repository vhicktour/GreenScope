//
//  FAQView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI

struct FAQView: View {
    @State private var expandedQuestions: Set<String> = []

    let faqItems = [
        ("What is GreenScope?", "GreenScope is an app that helps you make eco-friendly decisions."),
        ("How does barcode scanning work?", "We use AVFoundation to scan barcodes and fetch product information."),
        ("Is my data private?", "Yes, we comply with all data protection regulations.")
    ]

    var body: some View {
        List {
            ForEach(faqItems, id: \.0) { question, answer in
                Section {
                    Text(answer)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(expandedQuestions.contains(question) ? nil : 1)
                        .onTapGesture {
                            toggleQuestion(question)
                        }
                } header: {
                    Text(question)
                        .font(.headline)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("FAQ")
    }

    func toggleQuestion(_ question: String) {
        if expandedQuestions.contains(question) {
            expandedQuestions.remove(question)
        } else {
            expandedQuestions.insert(question)
        }
    }
}
