//
//  PetCollageView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 21/09/26.
//

import SwiftUI

// MARK: - Model

struct CollageTemplate {
    let photoCount: Int
    let columns: Int
    
    static let templates: [Int: CollageTemplate] = [
        2: CollageTemplate(photoCount: 2, columns: 1),
        4: CollageTemplate(photoCount: 4, columns: 2),
        6: CollageTemplate(photoCount: 6, columns: 2)
    ]
}

// MARK: - Main Collage View (this is what gets rendered/exported)

struct PetCollageView: View {
    let images: [UIImage]
    var tagline: String = "ENJOY YOUR LIFE"
    var subtitle: String = "Just breathing the air there was never a care."
    
    private let gutterSpacing: CGFloat = 16
    private let outerPadding: CGFloat = 24
    
    private var columns: Int {
        CollageTemplate.templates[images.count]?.columns ?? 2
    }
    
    var body: some View {
        VStack(spacing: 32) {
            // Photo grid
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: gutterSpacing), count: columns),
                spacing: gutterSpacing
            ) {
                ForEach(images.indices, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .clipped()
                }
            }
            
            // Footer branding block
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image("DrPawLogoMark") // small logo asset
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(tagline)
                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                        .kerning(2)
                }
                Text(subtitle)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .kerning(1)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 8)
        }
        .padding(outerPadding)
        .background(Color.white)
    }
}

// MARK: - Export helper (renders the SwiftUI view to a UIImage)

@MainActor
func renderCollageToImage(images: [UIImage], tagline: String, subtitle: String) -> UIImage? {
    let collageView = PetCollageView(images: images, tagline: tagline, subtitle: subtitle)
        .frame(width: 1080) // fixed export width for consistent quality across devices
    
    let renderer = ImageRenderer(content: collageView)
    renderer.scale = 3.0 // retina-quality export
    
    return renderer.uiImage
}

// MARK: - Screen that lets user pick photos + export/share

struct CollageCreatorScreen: View {
    @State private var selectedImages: [UIImage] = []
    @State private var showShareSheet = false
    @State private var exportedImage: UIImage?
    
    let photoCountOptions = [2, 4, 6]
    
    var body: some View {
        VStack {
            if !selectedImages.isEmpty {
                PetCollageView(images: selectedImages)
                    .padding()
            } else {
                Text("Select photos to preview your collage")
                    .foregroundColor(.gray)
            }
            
            // TODO: hook this up to your existing photo picker (PhotosPicker / PHPickerViewController)
            
            Button("Create & Share Collage") {
                exportedImage = renderCollageToImage(
                    images: selectedImages,
                    tagline: "ENJOY YOUR LIFE",
                    subtitle: "Just breathing the air there was never a care."
                )
                showShareSheet = exportedImage != nil
            }
            .disabled(selectedImages.isEmpty)
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = exportedImage {
                ShareSheet(activityItems: [image])
            }
        }
    }
}

// MARK: - UIKit share sheet wrapper (SwiftUI has no native one pre-iOS 16 share link for images)

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}


#Preview("Pet Collage - 4 Photos") {
    PetCollageView(
        images: [
            UIImage(systemName: "dog.fill")!,
            UIImage(systemName: "cat.fill")!,
            UIImage(systemName: "bird.fill")!,
            UIImage(systemName: "pawprint.fill")!
        ]
    )
    .padding()
}
