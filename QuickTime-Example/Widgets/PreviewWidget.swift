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
    
    @ViewState fileprivate var previewImage: CGImage?
    @ViewState fileprivate var displaySize: CGSize = .zero
    @ViewState fileprivate var offset = CGSize.zero
    
    required init(_ context: Context) {
        super.init(context)
        
        if let item = context[RenderService.self].player.currentItem {
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
            
            let displayWidth = 150.0
            let displayHeight = displayWidth * CGFloat(cgImage.height) / CGFloat(cgImage.width)
            let displaySize = CGSize(width: displayWidth, height: displayHeight)
            let offset = CGSize(
                width: targetRect.minX - displayWidth * 0.5 + offset,
                height: targetRect.minY - 150
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
        
        let pluginService = context[PluginService.self]
        if !pluginService.isBeingPresented {
            pluginService.present(.topLeading, animation: nil, transition: .identity) {
                AnyView(PreviewWidget())
            }
        }
    }
    
    func dismiss() {
        let pluginService = context[PluginService.self]
        pluginService.dismiss(animation: nil)
        
        context.stopService(PreviewWidgetService.self)
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
