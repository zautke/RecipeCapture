//
//  RecipeOCRView.swift
//  RecipeCapture
//
//  Created by [Your Name] on [Date].
//
//  This file contains the DetailView that displays the raw and processed images,
//  as well as the recognized text. The right detail pane is split vertically:
//    - Top half: Raw & processed images side by side.
//    - Bottom half: Recognized text on the left and a placeholder on the right.
//

import SwiftUI

struct DetailView: View {
    var item: TextItem?

    var body: some View {
        VStack(spacing: 0) {
            // TOP HALF: Raw and processed images side-by-side
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
            }
            .frame(maxHeight: .infinity)

            Divider()

            // BOTTOM HALF: Recognized text on the left, placeholder on the right
            GeometryReader { bottomGeo in
                HStack(spacing: 0) {
                    Text(item?.text ?? "No recognized text")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                    Divider()

                    // Placeholder for future parsed recipe section
                    Text("Parsed recipe here (future)")
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .frame(height: bottomGeo.size.height)
            }
            .frame(maxHeight: .infinity)
        }
    }
}
