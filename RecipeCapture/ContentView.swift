//
//  ContentView.swift
//  RecipeCapture
//
//  Created by [Your Name] on [Date].
//
//  Persistence: The recognized items are saved to disk and loaded on app launch.
//  Trimmed sidebar text: 40 chars.
//  Bottom detail panels are scrollable.
//  Automatically select the latest capture after OCR completes.
//

import SwiftUI

struct TextItem: Identifiable, Hashable, Codable {
    let id: UUID
    let text: String
    let rawImageData: Data
    let processedImageData: Data

    init(id: UUID = UUID(), text: String, rawImage: UIImage, processedImage: UIImage) {
        self.id = id
        self.text = text
        self.rawImageData = rawImage.pngData() ?? Data()
        self.processedImageData = processedImage.pngData() ?? Data()
    }

    var rawImage: UIImage? {
        UIImage(data: rawImageData)
    }

    var processedImage: UIImage? {
        UIImage(data: processedImageData)
    }
}

class RecognizedContent: ObservableObject {
    @Published var items: [TextItem] = []

    private let filename = "items.json"

    init() {
        loadItems()
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func loadItems() {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }

        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode([TextItem].self, from: data)
            self.items = decoded
        } catch {
            print("Error loading items: \(error)")
        }
    }

    func saveItems() {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: fileURL, options: .atomicWrite)
        } catch {
            print("Error saving items: \(error)")
        }
    }
}

struct ContentView: View {
    @ObservedObject var recognizedContent = RecognizedContent()
    @State private var showScanner = false
    @State private var isRecognizing = false
    @State private var selectedItem: TextItem?

    var body: some View {
        NavigationView {
            // Left pane: list of recognized items (trim to 40 chars)
            List(recognizedContent.items, selection: $selectedItem) { textItem in
                NavigationLink(
                    destination: DetailView(item: textItem),
                    tag: textItem,
                    selection: $selectedItem
                ) {
                    Text(String(textItem.text.prefix(40)) + (textItem.text.count > 40 ? "..." : ""))
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

            // Right pane: detail view
            DetailView(item: selectedItem)
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .sheet(isPresented: $showScanner, content: {
            ScannerView { result in
                switch result {
                case .success(let scannedImages):
                    isRecognizing = true
                    // When OCR completes, it adds a new item and calls completion.
                    TextRecognition(scannedImages: scannedImages, recognizedContent: recognizedContent) {
                        isRecognizing = false
                        // Automatically select the latest item
                        if let lastItem = recognizedContent.items.last {
                            selectedItem = lastItem
                        }
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
        .onChange(of: recognizedContent.items) { _ in
            recognizedContent.saveItems()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
