//
//  ProductViewModel.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import Foundation

class ProductViewModel: ObservableObject {
    @Published var product: Product?
    @Published var isLoading = false
    @Published var error: ProductError?
    
    private let productService = ProductService()
    
    func fetchProduct(byBarcode barcode: String) {
        isLoading = true
        error = nil
        
        productService.fetchProductDetails(byBarcode: barcode) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let product):
                    self?.product = product
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
}
