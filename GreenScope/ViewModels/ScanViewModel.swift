//
//  ScanViewModel.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import Foundation

class ScanViewModel: ObservableObject {
    @Published var scannedBarcode: String = ""
    @Published var productDetails: Product?
    @Published var isLoading = false
    @Published var error: ProductError?
    
    private let productService = ProductService()
    
    func handleBarcodeScanned(barcode: String) {
        scannedBarcode = barcode
        fetchProductDetails()
    }
    
    private func fetchProductDetails() {
        isLoading = true
        error = nil
        
        productService.fetchProductDetails(byBarcode: scannedBarcode) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let product):
                    self?.productDetails = product
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
}
