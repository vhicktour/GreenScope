//
//  ProfileViewModel.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var userName: String = "Eco Warrior"
    @Published var scannedProducts: [Product] = []
    @Published var favoriteProducts: [Product] = []

    func addToFavorites(product: Product) {
        if !favoriteProducts.contains(where: { $0.name == product.name }) {
            favoriteProducts.append(product)
        }
    }

    func removeFavorite(product: Product) {
        favoriteProducts.removeAll(where: { $0.name == product.name })
    }
}
