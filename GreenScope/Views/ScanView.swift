//
//  ScanView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI
import AVFoundation

struct ScanView: UIViewControllerRepresentable {
    @Binding var scannedCode: String
    var onScanComplete: (() -> Void)?

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: ScanView

        init(parent: ScanView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                if let code = metadataObject.stringValue {
                    DispatchQueue.main.async {
                        self.parent.scannedCode = code
                        self.parent.onScanComplete?()
                    }
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            return viewController
        }

        captureSession.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)

        metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.ean13, .ean8, .qr]

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        captureSession.startRunning()

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
