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
    
        WithService(SeekBarWidgetService.self) { service in
            Slider(value: service.seekProgressBinding, clickable: true, thumbContent: {
                Circle().fill(.white).frame(width:15, height:15)
            }, onEditingChanged: { startOrEnd in
                service.acceptProgress = !startOrEnd
                service.seekProgress(service.progress)
            })
            .disabled(service.progress == 0)
            .frame(height: 40)
            .tint(.white)
        }
    }
}

class SeekBarWidgetService : Service {
    
    @ViewState fileprivate var progress: Float = 0.0
    
    private var cancellables = [AnyCancellable]()
    
    private var timeObserver: Any?
    
    fileprivate var acceptProgress = true
    
    fileprivate var seekProgressBinding: Binding<Float> {
        Binding(get: {
            self.progress
        }, set: {
            self.updateProgress($0)
        })
    }
    
    required init(_ context: Context) {
        super.init(context)
        
        let renderService = context[RenderService.self]
        timeObserver = renderService.player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: nil) { [weak self] time in
            guard let item = renderService.player.currentItem else { return }
            guard item.duration.seconds.isNormal else { return }
            guard let self = self else { return }
            
            if self.acceptProgress {
                self.progress = Float(time.seconds / item.duration.seconds)
            }
        }
        
        let gestureService = context[GestureService.self]
        let viewSizeService = context[ViewSizeService.self]
        
        gestureService.observe(.drag(.horizontal)) { event in
            
            switch event.action {
            case .start: break
            case .end:
                
                guard let item = renderService.player.currentItem else { return }
                guard item.duration.seconds.isNormal else { return }
                guard case let .drag(value) = event.value else { return }
                
                let percent = value.translation.width / viewSizeService.width
                let secs = item.duration.seconds * percent
                let current = item.currentTime().seconds
                renderService.player.seek(to: CMTime(value: Int64(current + secs), timescale: 1), toleranceBefore: .zero, toleranceAfter: .zero) { _ in }
            }
        }.store(in: &cancellables)
    }
    
    fileprivate func updateProgress(_ progress: Float) {
        self.progress = progress
    }
    
    fileprivate func seekProgress(_ progress: Float) {
        
        let service = context[RenderService.self]
        
        guard let item = service.player.currentItem else { return }
        guard item.duration.seconds.isNormal else { return }
        
        let target = item.duration.seconds * Float64(progress)
        
        service.player.seek(to: CMTime(value: Int64(target), timescale: 1), toleranceBefore: .zero, toleranceAfter: .zero) { _ in
            
        }
    }
}
