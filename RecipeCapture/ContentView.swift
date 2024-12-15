//
//  ContentView.swift
//  RecipeCapture
//
//  Created by [Your Name] on [Date].
//
//  This file contains the main UI with a split view:
//    - Left (master): A list of recognized items.
//    - Right (detail): Provided by DetailView in RecipeOCRView.swift.
//
//  It also initiates scanning (via ScannerView in RecipeCameraOCRView.swift),
//  triggers OCR processing (via TextRecognition in RecipeOCRTrainerView.swift),
//  and manages the recognized items (via RecognizedContent).
//

import SwiftUI

struct TextItem: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let rawImage: UIImage
    let processedImage: UIImage
}

class RecognizedContent: ObservableObject {
    @Published var items: [TextItem] = []
}

struct ContentView: View {
    @ObservedObject var recognizedContent = RecognizedContent()
    @State private var showScanner = false
    @State private var isRecognizing = false
    @State private var selectedItem: TextItem?

    var body: some View {
        NavigationView {
            // Left pane: list of recognized items
            List(recognizedContent.items, selection: $selectedItem) { textItem in
                NavigationLink(
                    destination: DetailView(item: textItem),
                    tag: textItem,
                    selection: $selectedItem
                ) {
                    Text(String(textItem.text.prefix(50)).appending("..."))
                }
            }
            .navigationTitle("Text Scanner")
            .navigationBarItems(trailing:
                Button(action: {
                    guard !isRecognizing else { return }
                    showScanner = true
                }, label: {
                    HStack {
                        Image(systemName: "doc.text.viewfinder")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                        Text("Scan")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 36)
                    .background(Color(UIColor.systemIndigo))
                    .cornerRadius(18)
                })
            )
            
            // Right pane
            DetailView(item: selectedItem)
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .sheet(isPresented: $showScanner, content: {
            ScannerView { result in
                switch result {
                case .success(let scannedImages):
                    isRecognizing = true
                    TextRecognition(scannedImages: scannedImages, recognizedContent: recognizedContent) {
                        isRecognizing = false
                    }
                    .recognizeText()
                case .failure(let error):
                    print("Scanning error: \(error.localizedDescription)")
                }
                showScanner = false
            } didCancelScanning: {
                showScanner = false
            }
        })
        .overlay(
            Group {
                if isRecognizing {
                    ZStack {
                        Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                        ProgressView("Recognizing...")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                }
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
