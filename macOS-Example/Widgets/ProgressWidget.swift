//
//  ProgressWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/19.
//

import Foundation
import AVKit
import SwiftUI
import Combine
import VideoPlayerContainer

struct ProgressWidget : View {
    
    var body: some View {
    
        WithService(ProgressService.self) { service in
            Slider(value: Binding(get: {
                service.progress
            }, set: { value, _ in
                service.updateProgress(value)
            })) { startOrEnd in
                service.acceptProgress = !startOrEnd
                service.seekProgress(service.progress)
            }
            .disabled(service.progress == 0)
        }
    }
}

class ProgressService : Service {
    
    @ViewState fileprivate var progress = 0.0
    
    private var cancellables = [AnyCancellable]()
    
    private var timeObserver: Any?
    
    fileprivate var acceptProgress = true
    
    required init(_ context: Context) {
        super.init(context)
        
        let renderService = context[RenderService.self]
        timeObserver = renderService.player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: nil) { [weak self] time in
            guard let item = renderService.player.currentItem else { return }
            guard item.duration.seconds.isNormal else { return }
            guard let self = self else { return }
            
            if self.acceptProgress {
                self.progress = time.seconds / item.duration.seconds
            }
        }
        
        let gestureService = context[GestureService.self]
        let viewSizeService = context[ViewSizeService.self]
        
        gestureService.observeDrag { event in
            
            switch event {
            case .changed(_):
                break
            case let .end(value):
                
                guard let item = renderService.player.currentItem else { return }
                guard item.duration.seconds.isNormal else { return }
                let percent = value.translation.width / viewSizeService.width
                let secs = item.duration.seconds * percent
                let current = item.currentTime().seconds
                renderService.player.seek(to: CMTime(value: Int64(current + secs), timescale: 1), toleranceBefore: .zero, toleranceAfter: .zero) { _ in }
            }
        }.store(in: &cancellables)
    }
    
    fileprivate func updateProgress(_ progress: CGFloat) {
        self.progress = progress
    }
    
    fileprivate func seekProgress(_ progress: CGFloat) {
        
        let service = context[RenderService.self]
        
        guard let item = service.player.currentItem else { return }
        guard item.duration.seconds.isNormal else { return }
        
        let target = item.duration.seconds * Float64(progress)
        
        service.player.seek(to: CMTime(value: Int64(target), timescale: 1), toleranceBefore: .zero, toleranceAfter: .zero) { _ in
            
        }
    }
}
