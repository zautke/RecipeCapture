//
//  RecipeOCRTrainerView.swift
//  RecipeCapture
//
//  Created by Luke Zautke on 12/15/24.
//


import SwiftUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

struct RecipeOCRTrainerView: View {
    @StateObject private var cameraModel = CameraViewModel()
    @State private var recognizedText: String = ""
    @State private var corrections: [String: String] = [:]
    @State private var currentImage: UIImage?

    var body: some View {
        ZStack {
            CameraView(session: cameraModel.session)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                HStack {
                    Button(action: {
                        cameraModel.capturePhoto { image in
                            currentImage = preprocessImage(image: image)
                            processImage(image: currentImage!)
                        }
                    }) {
                        Text("Scan Now")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()

                    Button(action: {
                        saveCorrections()
                    }) {
                        Text("Save Feedback")
                            .font(.headline)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            cameraModel.setupCamera()
        }
        .alert("OCR Results", isPresented: Binding<Bool>(
            get: { !recognizedText.isEmpty },
            set: { _ in recognizedText = "" }
        )) {
            TextField("Correct text here", text: Binding(
                get: { corrections[recognizedText] ?? "" },
                set: { corrections[recognizedText] = $0 }
            ))
        } message: {
            Text(recognizedText)
        }
    }

    /// Preprocess the image to improve OCR results
    func preprocessImage(image: UIImage) -> UIImage {
        guard let inputCIImage = CIImage(image: image) else { return image }
        
        let context = CIContext()

        // Step 1: Grayscale conversion
        let grayscaleFilter = CIFilter.photoEffectMono()
        grayscaleFilter.inputImage = inputCIImage

        // Step 2: Denoising
        let denoiseFilter = CIFilter.gaussianBlur()
        denoiseFilter.inputImage = grayscaleFilter.outputImage
        denoiseFilter.radius = 1.0 // Fine-tune as needed

        // Step 3: Contrast enhancement
        let contrastFilter = CIFilter.colorControls()
        contrastFilter.inputImage = denoiseFilter.outputImage
        contrastFilter.contrast = 1.5 // Adjust contrast level

        // Step 4: Thresholding
        let thresholdFilter = CIFilter(name: "CIThresholdToZero")
        thresholdFilter?.setValue(contrastFilter.outputImage, forKey: kCIInputImageKey)

        // Step 5: Edge enhancement (Optional for fine-tuning)
        let edgesFilter = CIFilter.edges()
        edgesFilter.inputImage = thresholdFilter?.outputImage
        edgesFilter.intensity = 2.0

        // Step 6: Generate output
        let outputImage = edgesFilter.outputImage ?? inputCIImage
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return image
    }

    /// Process the image using Vision framework for OCR
    func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("Error recognizing text: \(error)")
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

            // Extract recognized text
            let extractedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            DispatchQueue.main.async {
                recognizedText = extractedText
            }
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

    /// Save user feedback and corrections for retraining
    func saveCorrections() {
        let feedbackFileURL = getDocumentsDirectory().appendingPathComponent("feedback.json")

        do {
            let jsonData = try JSONEncoder().encode(corrections)
            try jsonData.write(to: feedbackFileURL)
            print("Feedback saved successfully at \(feedbackFileURL)")
        } catch {
            print("Error saving feedback: \(error)")
        }
    }

    /// Helper function to get the document directory
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}