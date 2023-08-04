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

fileprivate class SeekBarWidgetService : Service {
    
    @ViewState var progress: Float = 0.0
    
    private var cancellables = [AnyCancellable]()
    
    private var timeObserver: Any?
    
    var acceptProgress = true
    
    var seekProgressBinding: Binding<Float> {
        Binding(get: {
            self.progress
        }, set: {
            self.updateProgress($0)
        })
    }
    
    required init(_ context: Context) {
        super.init(context)
        
        timeObserver = context.render.player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: nil) { [weak self, weak context] time in
            guard let self, let context else { return }
            guard let item = context.render.player.currentItem else { return }
            guard item.duration.seconds.isNormal else { return }
            
            if self.acceptProgress {
                self.progress = Float(time.seconds / item.duration.seconds)
            }
        }
        
        context.gesture.observe(.drag(.horizontal)) { [weak context] event in
            guard let context else { return }
            
            switch event.action {
            case .start: break
            case .end:
                
                guard let item = context.render.player.currentItem else { return }
                guard item.duration.seconds.isNormal else { return }
                guard case let .drag(value) = event.value else { return }
                
                let percent = value.translation.width / context.viewSize.width
                let secs = item.duration.seconds * percent
                let current = item.currentTime().seconds
                context.render.player.seek(to: CMTime(value: Int64(current + secs), timescale: 1), toleranceBefore: .zero, toleranceAfter: .zero) { _ in }
            }
        }.store(in: &cancellables)
    }
    
    func updateProgress(_ progress: Float) {
        self.progress = progress
    }
    
    func seekProgress(_ progress: Float) {
        
        guard let item = context.render.player.currentItem else { return }
        guard item.duration.seconds.isNormal else { return }
        
        let target = item.duration.seconds * Float64(progress)
        context.render.player.seek(to: CMTime(value: Int64(target), timescale: 1), toleranceBefore: .zero, toleranceAfter: .zero) { _ in }
    }
}
