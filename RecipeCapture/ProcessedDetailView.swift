//
//  ProcessedDetailView.swift
//  RecipeCapture
//
//  Created by Luke Zautke on 12/15/24.
//


import SwiftUI

struct ProcessedDetailView: View {
    // Example placeholders; replace these with actual bindings or @State properties
    @State var rawImage: UIImage = UIImage(named: "raw_image_example") ?? UIImage()
    @State var processedImage: UIImage = UIImage(named: "processed_image_example") ?? UIImage()
    @State var recognizedText: String = "Recognized text goes here..."
    @State var parsedRecipe: String = "Parsed recipe details go here..."

    var body: some View {
        NavigationView {
            // The left side (master) content, could be a list or something else
            List {
                Text("Recipe Items")
                // ...
            }
            // Right side (detail) layout
            .navigationSplitViewColumnWidth(ideal: 300) // Adjust as needed
            .navigationTitle("Recipes")
            
            // The detail view using a vertical stack (top half for images, bottom half for text)
            VStack(spacing: 0) {
                // TOP HALF
                GeometryReader { topGeo in
                    HStack(spacing: 80) {
                        Spacer()
                        Image(uiImage: rawImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                        
                        Image(uiImage: processedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                        Spacer()
                    }
                    .frame(height: topGeo.size.height) // Fill the top half
                }
                .frame(maxHeight: .infinity)
                
                Divider()

                // BOTTOM HALF
                GeometryReader { bottomGeo in
                    HStack(spacing: 0) {
                        // Raw recognized text side
                        Text(recognizedText)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        
                        Divider()
                        
                        // Parsed recipe side
                        Text(parsedRecipe)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
                    .frame(height: bottomGeo.size.height)
                }
                .frame(maxHeight: .infinity)
            }
            // Use a split view style if on macOS or adapt for iPad. On iOS, the NavigationView will handle master/detail.
        }
    }
}

struct ProcessedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessedDetailView()
    }
}