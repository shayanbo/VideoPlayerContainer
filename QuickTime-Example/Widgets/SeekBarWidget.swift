//
//  SeekBarWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/19.
//

import Foundation
import AVKit
import SwiftUI
import Combine
import VideoPlayerContainer

struct SeekBarWidget : View {
    
    var body: some View {
    
        GeometryReader { proxy in
            WithService(SeekBarWidgetService.self) { service in
                Slider(value: service.binding) { startOrEnd in
                    if startOrEnd {
                        service.acceptProgress = false
                    } else {
                        service.seekProgress(service.progress)
                    }
                }
                .disabled(service.progress == 0)
                .tint(.white)
                .onContinuousHover { phase in
                    switch phase {
                    case .active(let location):
                        service.presentPreview()
                        service.adjustPreview(hoverPoint: location, proxy: proxy)
                    case .ended:
                        service.dismissPreview()
                    }
                }
            }
        }
        .frame(height: 20)
    }
}

fileprivate class SeekBarWidgetService : Service {
    
    @ViewState var progress = 0.0
    
    var binding: Binding<Double> {
        Binding {
            self.progress
        } set: {
            self.progress = $0
        }
    }
    
    private var timeObserver: Any?
    private var itemObservation: NSKeyValueObservation?
    
    /// The boolean value that indicates whether accept progress value from the AVPlayer timer.
    /// Since we need to keep the knob goes with the mouse when users are dragging
    var acceptProgress = true
    
    
    
    required init(_ context: Context) {
        super.init(context)
        
        let player = context[RenderService.self].player
        
        /// Sync with AVPlayer timer
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: nil) { [weak self] time in
            guard let item = player.currentItem else { return }
            guard item.duration.seconds.isNormal else { return }
            guard let self = self else { return }
            
            if self.acceptProgress {
                self.progress = time.seconds / item.duration.seconds
            }
        }
    }
    
    //MARK: Seek
    
    func seekProgress(_ progress: CGFloat) {
        
        let service = context[RenderService.self]
        
        guard let item = service.player.currentItem else { return }
        guard item.duration.seconds.isNormal else { return }
        
        let target = item.duration.seconds * Float64(progress)
        service.player.seek(to: CMTime(value: Int64(target), timescale: 1), toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            self?.acceptProgress = true
        }
    }
    
    //MARK: Preview
    
    func adjustPreview(hoverPoint: CGPoint, proxy: GeometryProxy) {
        
        guard let item = context[RenderService.self].player.currentItem else {
            return
        }
        
        /// Percent value for the hover progress
        let progress = min(1.0, max(0.0, hoverPoint.x / proxy.size.width))
        
        /// Slider frame located in the whole VideoPlayerContainer
        let sliderFrame = proxy.frame(in: .containerSpace)
        
        if item.duration.seconds.isNaN {
            return
        }
        
        /// Create the timestamp where the mouse hovers on
        let target = item.duration.seconds * Float64(progress)
        let timePoint = CMTime(value: Int64(target), timescale: 1)
        
        let previewService = context[PreviewWidgetService.self]
        previewService.preview(timePoint, targetRect: sliderFrame, offset: sliderFrame.width * progress)
    }
    
    func presentPreview() {
        context[PreviewWidgetService.self].present()
    }
    
    func dismissPreview() {
        context[PreviewWidgetService.self].dismiss()
    }
}
