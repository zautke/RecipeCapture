//
//  TextRecognition.swift
//  ScanAndRecognizeText
//
//  Created by Gabriel Theodoropoulos.
//

import SwiftUI
import Vision

@MainActor
struct TextRecognition {
    var scannedImages: [UIImage]
    @ObservedObject var recognizedContent: RecognizedContent
    var didFinishRecognition: () -> Void
    
    
    func recognizeText() {
        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
        queue.sync {
            Task {
                for image in scannedImages {
                    guard let cgImage = image.cgImage else { return }
                    
                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                    
                    do {
                        let textItem = TextItem()

                        // Create the request directly in the background thread
                        let request = getTextRecognitionRequest(with: textItem)
                        
                        try requestHandler.perform([request])
                        
                        await MainActor.run {
                            recognizedContent.items.append(textItem)
                        }
                    } catch {
                        print("Error during text recognition: \(error.localizedDescription)")
                    }
                    
                    await MainActor.run {
                        didFinishRecognition()
                    }
                }
            }
        }
    }
    
    
    private func getTextRecognitionRequest(with textItem: TextItem) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            observations.forEach { observation in
                guard let recognizedText = observation.topCandidates(1).first else { return }
                textItem.text += recognizedText.string
                textItem.text += "\n"
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        return request
    }
}
