//
//  RecipeCameraOCRView.swift
//  RecipeCapture
//
//  Created by Luke Zautke on 12/15/24.
//


import SwiftUI
import AVFoundation
import Vision

struct RecipeCameraOCRView: View {
    @StateObject private var cameraModel = CameraViewModel()
    @State private var recognizedText: String = ""

    var body: some View {
        ZStack {
            CameraView(session: cameraModel.session)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                Button(action: {
                    cameraModel.capturePhoto { image in
                        processImage(image: image)
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
            }
        }
        .onAppear {
            cameraModel.setupCamera()
        }
        .alert("OCR Results", isPresented: Binding<Bool>(
            get: { !recognizedText.isEmpty },
            set: { _ in recognizedText = "" }
        )) {
            Text(recognizedText)
        }
    }

    private func processImage(image: UIImage) {
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
}

// Camera ViewModel
class CameraViewModel: ObservableObject {
    @Published var session = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()

    func setupCamera() {
        session.beginConfiguration()
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }

        session.commitConfiguration()
        session.startRunning()
    }

    func capturePhoto(completion: @escaping (UIImage) -> Void) {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: PhotoCaptureProcessor(completion: completion))
    }
}

// Camera View
struct CameraView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

// Photo Capture Processor
class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    private let completion: (UIImage) -> Void

    init(completion: @escaping (UIImage) -> Void) {
        self.completion = completion
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }

        completion(image)
    }
}