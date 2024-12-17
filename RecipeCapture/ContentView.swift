//
//  ContentView.swift
//  RecipeCapture
//
//  Changes:
//    - Persistence as before.
//    - Trim sidebar text to 40 chars and one line.
//    - Automatically select the latest capture after OCR.
//    - No changes to pinch zoom or spacing logic here, all logic done in DetailView.
//
//  We ensure the sidebar text shows only one line using .lineLimit(1).
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

    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        NavigationView {
            // Sidebar with recognized text items
            SidebarView(
                recognizedContent: recognizedContent,
                selectedItem: $selectedItem,
                isDarkMode: isDarkMode
            )
            .navigationTitle("Text Scanner")
            .navigationBarItems(trailing: toolbarContent)

            // Detail view for the selected item
            DetailView(item: selectedItem)
                .background(sol.base3)
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .sheet(isPresented: $showScanner, content: showScannerContent)
        .overlay(isRecognizingOverlay)
        .onChange(of: recognizedContent.items, perform: { _ in
            recognizedContent.saveItems()
        })
        .preferredColorScheme(isDarkMode ? .dark : .light) // Dynamic theme switch
    }

    // Refactor navigation bar items into a computed property
    private var toolbarContent: some View {
        let darkModeIcon = isDarkMode ? "sun.max.fill" : "moon.fill"
        let scanButtonBackground = sol.highlight_bg
        let scanButtonTextColor = sol.primary_text

        return HStack {
            // Button to toggle between light and dark mode
            Button(action: { isDarkMode.toggle() }) {
                Image(systemName: darkModeIcon)
                    .font(.title2)
                    .foregroundColor(scanButtonTextColor)
            }

            // Button to open the scanner
            Button(action: { guard !isRecognizing else { return }; showScanner = true }) {
                HStack {
                    Image(systemName: "doc.text.viewfinder")
                        .renderingMode(.template)
                        .foregroundColor(scanButtonTextColor)
                    Text("Scan")
                        .foregroundColor(scanButtonTextColor)
                }
                .padding(.horizontal, 16)
                .frame(height: 36)
                .background(scanButtonBackground)
                .cornerRadius(18)
            }
        }
    }

    // Refactor scanner content into a method
    private func showScannerContent() -> some View {
        ScannerView { result in
            switch result {
            case .success(let scannedImages):
                isRecognizing = true
                TextRecognition(scannedImages: scannedImages, recognizedContent: recognizedContent) {
                    isRecognizing = false
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
    }

    // Recognizing overlay during OCR processing
    private var isRecognizingOverlay: some View {
        Group {
            if isRecognizing {
                ZStack {
                    sol.base03.opacity(0.4).edgesIgnoringSafeArea(.all)
                    ProgressView("Recognizing...")
                        .padding()
                        .background(sol.highlight_bg)
                        .cornerRadius(10)
                        .foregroundColor(sol.primary_text)
                }
            }
        }
    }
}

struct SidebarView: View {
    @ObservedObject var recognizedContent: RecognizedContent
    @Binding var selectedItem: TextItem?
    var isDarkMode: Bool

    var body: some View {
        List(recognizedContent.items, selection: $selectedItem) { textItem in
            NavigationLink(
                destination: DetailView(item: textItem),
                tag: textItem,
                selection: $selectedItem
            ) {
                Text(String(textItem.text.prefix(40)) + (textItem.text.count > 40 ? "..." : ""))
                    .lineLimit(1)
                    .foregroundColor(sol.primary_text)
            }
            .listRowBackground(sol.base3)
        }
        .background(sol.base3)
    }
}
