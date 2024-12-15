//
//  RecipeOCRView.swift
//  RecipeCapture
//
//  Changes:
//    - Pinch-to-zoom now also adjusts spacing between images. As scale increases beyond 1.0, spacing shrinks linearly until 0 at scale 2.0.
//    - If scale < 1.0, we clamp it back to 1.0 when gesture ends, so spacing won't exceed original.
//    - Added a zoom reset icon (magnifying glass with slash) in the upper right of the bottom pane, which resets scale to 1.0.
//
//  Layout:
//    - Top half: Raw & processed images side by side with dynamic spacing and pinch-to-zoom.
//    - Bottom half: Recognized text on the left (scrollable), placeholder on the right (scrollable).
//      A zoom reset button appears in the top-right corner of this bottom section.
//

import SwiftUI

struct DetailView: View {
    var item: TextItem?
    @State private var scale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { topGeo in
                // Calculate spacing: at scale=1, spacing=80. At scale=2, spacing=0.
                // spacing = max(80 - 80*(scale-1),0) = max(80*(2-scale),0)
                let spacing = max(80 * (2 - scale), 0)

                HStack(spacing: spacing) {
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

            ZStack(alignment: .topTrailing) {
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
                            Text("Parsed recipe here (future)")
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: bottomGeo.size.height)
                }

                // Zoom reset button in the top right corner of the bottom pane
                Button(action: {
                    withAnimation(.spring()) {
                        scale = 1.0
                    }
                }) {
                    // A magnifying glass plus a slash overlay
                    ZStack {
                        Image(systemName: "magnifyingglass.circle")
                            .font(.title)
                            .foregroundColor(.white)
                        Image(systemName: "slash.circle")
                            .font(.caption)
                            .foregroundColor(.red)
                            .offset(x: 8, y: -8)
                    }
                }
                .padding(.trailing, 16)
                .padding(.top, 16)
            }
            .frame(maxHeight: .infinity)
        }
    }
}
