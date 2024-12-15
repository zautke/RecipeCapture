//
//  RecipeOCRTrainerView.swift
//  RecipeCapture
//
//  Created by [Your Name] on [Date].
//
//  This file contains the TextRecognition class that handles:
//    - Preprocessing the captured image to improve OCR results.
//    - Performing OCR via Vision on the preprocessed image.
//
//  The recognized text and images are then stored in RecognizedContent.
//

import UIKit
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

class TextRecognition {
    private let scannedImages: [UIImage]
    private let recognizedContent: RecognizedContent
    private let completion: () -> Void

    init(scannedImages: [UIImage], recognizedContent: RecognizedContent, completion: @escaping () -> Void) {
        self.scannedImages = scannedImages
        self.recognizedContent = recognizedContent
        self.completion = completion
    }

    func recognizeText() {
        guard let rawImage = scannedImages.first else {
            completion()
            return
        }

        // Preprocess image
        let processedImage = preprocessImage(image: rawImage)
        
        // Perform OCR on processedImage
        performOCR(on: processedImage) { recognizedText in
            DispatchQueue.main.async {
                let newItem = TextItem(text: recognizedText, rawImage: rawImage, processedImage: processedImage)
                self.recognizedContent.items.append(newItem)
                self.completion()
            }
        }
    }

    private func performOCR(on image: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else {
            completion("")
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("Error recognizing text: \(error)")
                completion("")
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion("")
                return
            }

            let extractedText = observations.compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            completion(extractedText)
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

    /// Preprocess the image to potentially improve OCR results
    private func preprocessImage(image: UIImage) -> UIImage {
        guard let inputCIImage = CIImage(image: image) else { return image }

        let context = CIContext()

        // Step 1: Grayscale conversion
        let grayscaleFilter = CIFilter.photoEffectMono()
        grayscaleFilter.inputImage = inputCIImage

        // Step 2: Light denoising
        let denoiseFilter = CIFilter.gaussianBlur()
        denoiseFilter.inputImage = grayscaleFilter.outputImage
        denoiseFilter.radius = 1.0

        // Step 3: Contrast enhancement
        let contrastFilter = CIFilter.colorControls()
        contrastFilter.inputImage = denoiseFilter.outputImage
        contrastFilter.contrast = 1.5

        guard let finalOutput = contrastFilter.outputImage else {
            return image
        }

        if let cgImage = context.createCGImage(finalOutput, from: finalOutput.extent) {
            return UIImage(cgImage: cgImage)
        }

        return image
    }
}
