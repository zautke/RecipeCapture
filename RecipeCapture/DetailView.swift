//
//  RecipeOCRView.swift
//  RecipeCapture
//
//  Created by [Your Name] on [Date].
//
//  This file contains the DetailView that displays the raw and processed images,
//  as well as the recognized text.
//
//  Changes:
//    - Uses matchedGeometryEffect for a stylish animation when transitioning to full-size images.
//    - Removed the explicit transition modifier to prevent conflicts with matchedGeometryEffect.
//    - Ensures both sets of images remain in view during the animation.
//    - On long press of the thumbnails, a full-size overlay appears, and tapping that overlay dismisses it.
//
import SwiftUI

struct DetailView: View {
    var item: TextItem?
    @State private var showFullSizeImages = false
    @Namespace private var imageAnimation

    var body: some View {
        ZStack {
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
                                .matchedGeometryEffect(id: "rawImage", in: imageAnimation)
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
                                .matchedGeometryEffect(id: "processedImage", in: imageAnimation)
                        } else {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 200, height: 200)
                                .overlay(Text("No Image").foregroundColor(.white))
                        }
                        Spacer()
                    }
                    .frame(height: topGeo.size.height)
                    // Long-press gesture to open the full-size overlay
                    .gesture(
                        LongPressGesture().onEnded { _ in
                            withAnimation(.spring()) {
                                showFullSizeImages = true
                            }
                        }
                    )
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

            // Fullscreen overlay for large images
            if showFullSizeImages {
                FullSizeImagesView(
                    rawImage: item?.rawImage,
                    processedImage: item?.processedImage,
                    imageAnimation: imageAnimation
                ) {
                    // On tap dismiss
                    withAnimation(.spring()) {
                        showFullSizeImages = false
                    }
                }
            }
        }
    }
}

struct FullSizeImagesView: View {
    var rawImage: UIImage?
    var processedImage: UIImage?
    var imageAnimation: Namespace.ID
    var onDismiss: () -> Void

    @State private var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            Color.black.opacity(0.9).edgesIgnoringSafeArea(.all)

            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                HStack(spacing: 80) {
                    if let raw = rawImage {
                        Image(uiImage: raw)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(40)
                            .matchedGeometryEffect(id: "rawImage", in: imageAnimation)
                    }
                    if let processed = processedImage {
                        Image(uiImage: processed)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(40)
                            .matchedGeometryEffect(id: "processedImage", in: imageAnimation)
                    }
                }
                .scaleEffect(scale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = value
                        }
                        .onEnded { _ in
                            if scale < 1.0 { scale = 1.0 }
                        }
                )
            }
        }
        .onTapGesture {
            onDismiss()
        }
    }
}
