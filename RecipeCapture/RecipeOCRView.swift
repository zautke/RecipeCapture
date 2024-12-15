//
//  RecipeOCRView.swift
//  RecipeCapture
//
//  Created by Luke Zautke on 12/15/24.
//


import SwiftUI
import Vision
import CoreML
import NaturalLanguage

struct RecipeOCRView: View {
    @State private var recognizedText: String = ""
    @State private var feedbackText: String = ""
    @State private var unrecognizedTokens: [String] = []

    var body: some View {
        VStack {
            Text("OCR Recognized Text")
                .font(.headline)
            ScrollView {
                Text(recognizedText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            TextField("Feedback for Unrecognized Tokens", text: $feedbackText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Process Image") {
                processImage()
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Button("Submit Feedback") {
                handleFeedback()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }

    func processImage() {
        // Use VNRecognizeTextRequest to OCR a recipe image
        guard let image = UIImage(named: "sample_recipe")?.cgImage else { return }

        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            let extractedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            recognizedText = extractedText
            
            // Extract unrecognized tokens using NLP
            unrecognizedTokens = extractUnrecognizedTokens(from: extractedText)
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        try? handler.perform([request])
    }

    func extractUnrecognizedTokens(from text: String) -> [String] {
        // NLP Tokenization and Error Detection
        var tokens: [String] = []
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = text

        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass) { tag, tokenRange in
            if let tag = tag, tag == .otherWord { // Detect potential errors
                tokens.append(String(text[tokenRange]))
            }
            return true
        }
        return tokens
    }

    func handleFeedback() {
        // Store feedback and update model or correction logic
        unrecognizedTokens.append(feedbackText)
        feedbackText = ""

        // Log tokens for potential model retraining
        print("Feedback submitted. Unrecognized tokens:", unrecognizedTokens)
    }
}