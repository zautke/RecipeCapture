//
//  RecipeCameraOCRView.swift
//  RecipeCapture
//
//  Created by [Your Name] on [Date].
//
//  This file contains the ScannerView which uses the VisionKit
//  VNDocumentCameraViewController to capture images from the camera.
//  The captured images are returned to ContentView for OCR processing.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    var didFinishScanning: ((Result<[UIImage], Error>) -> Void)
    var didCancelScanning: (() -> Void)

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerVC = VNDocumentCameraViewController()
        scannerVC.delegate = context.coordinator
        return scannerVC
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(didFinishScanning: didFinishScanning, didCancelScanning: didCancelScanning)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var didFinishScanning: ((Result<[UIImage], Error>) -> Void)
        var didCancelScanning: (() -> Void)

        init(didFinishScanning: @escaping ((Result<[UIImage], Error>) -> Void),
             didCancelScanning: @escaping (() -> Void)) {
            self.didFinishScanning = didFinishScanning
            self.didCancelScanning = didCancelScanning
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var images: [UIImage] = []
            for i in 0..<scan.pageCount {
                images.append(scan.imageOfPage(at: i))
            }
            controller.dismiss(animated: true) {
                self.didFinishScanning(.success(images))
            }
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true) {
                self.didCancelScanning()
            }
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            controller.dismiss(animated: true) {
                self.didFinishScanning(.failure(error))
            }
        }
    }
}
