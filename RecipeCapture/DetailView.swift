//
//  RecipeOCRView.swift
//  RecipeCapture
//
//  This file contains the DetailView that displays the raw and processed images,
//  as well as the recognized text.
//
//  Layout:
//    - Top half: Raw & processed images side by side (200x200 each, 80 pts spacing), pinch-to-zoom.
//    - Bottom half: Recognized text on the left (scrollable), placeholder on the right (scrollable).
//

import SwiftUI

struct DetailView: View {
    var item: TextItem?
    @State private var scale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 0) {
            // TOP HALF: Raw and processed images side-by-side with pinch-to-zoom
            GeometryReader { topGeo in
                HStack(spacing: 80) {
                    Spacer()
                    if let rawImage = item?.rawImage {
                        Image(uiImage: rawImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    } else {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 200, height: 200)
                            .overlay(Text("No Image").foregroundColor(.white))
                    }

                    if let processedImage = item?.processedImage {
                        Image(uiImage: processedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    } else {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 200, height: 200)
                            .overlay(Text("No Image").foregroundColor(.white))
                    }
                    Spacer()
                }
                .frame(height: topGeo.size.height)
                .scaleEffect(scale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = value
                        }
                        .onEnded { _ in
                            if scale < 1.0 {
                                scale = 1.0
                            }
                        }
                )
            }
            .frame(maxHeight: .infinity)

            Divider()

            // BOTTOM HALF: Recognized text on the left (scrollable), placeholder on the right (scrollable)
            GeometryReader { bottomGeo in
                HStack(spacing: 0) {
                    ScrollView {
                        Text(item?.text ?? "No recognized text")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Divider()

                    ScrollView {
                        // Placeholder for future parsed recipe section
                        Text("Parsed recipe here (future)")
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: bottomGeo.size.height)
            }
            .frame(maxHeight: .infinity)
        }
    }
}
