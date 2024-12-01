//
//  PreviewWidget.swift
//  QuickTime-Example
//
//  Created by shayanbo on 2023/8/3.
//

import SwiftUI
import VideoPlayerContainer
import AVKit

class PreviewWidgetService: Service {
    
    /// Preview Image Generator
    fileprivate var imageGenerator: AVAssetImageGenerator?
    
    @Published fileprivate var previewImage: CGImage?
    @Published fileprivate var displaySize: CGSize = .zero
    @Published fileprivate var offset = CGSize.zero
    
    required init(_ context: Context) {
        super.init(context)
        
        if let item = context.render.player.currentItem {
            self.imageGenerator = AVAssetImageGenerator(asset: item.asset)
        }
    }
    
    deinit {
        self.imageGenerator?.cancelAllCGImageGeneration()
    }
    
    func preview(_ timestamp: CMTime, targetRect: CGRect, offset: CGFloat) {
        
        /// Obtain snapshot from the AVPlayer and display as preview
        imageGenerator?.generateCGImageAsynchronously(for: timestamp) { cgImage, time, error in
            
            guard let cgImage = cgImage else { return }
            
            let displaySize = AVMakeRect(aspectRatio: CGSize(width: cgImage.width, height: cgImage.height), insideRect: CGRect(origin: .zero, size: CGSize(width: 150.0, height: 150.0))).size
            
            let offset = CGSize(
                width: targetRect.minX - displaySize.width * 0.5 + offset,
                height: targetRect.minY - 60 - displaySize.height
            )
            
            /// Update Preview
            DispatchQueue.main.async {
                self.previewImage = cgImage
                self.displaySize = displaySize
                self.offset = offset
            }
        }
    }
    
    func present() {
        guard let context else { return }
        if !context.plugin.isBeingPresented {
            context.plugin.present(.topLeading, animation: nil, transition: .identity) {
                AnyView(PreviewWidget())
            }
        }
    }
    
    func dismiss() {
        context?.plugin.dismiss(animation: nil)
        context?.stopService(PreviewWidgetService.self)
    }
}

struct PreviewWidget: View {
    var body: some View {
        WithService(PreviewWidgetService.self) { service in
            if let preview = service.previewImage {
                Image(preview, scale: 1.0, label: Text("Preview"))
                    .resizable()
                    .frame(width: service.displaySize.width, height: service.displaySize.height)
                    .cornerRadius(5)
                    .offset(service.offset)
            }
        }
    }
}
