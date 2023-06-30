//
//  TimelineWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/19.
//

import Foundation
import AVKit
import Combine
import SwiftUI
import VideoPlayerContainer

struct TimelineWidget : View {
    
    var body: some View {
        
        WithService(TimelineService.self) { service in
            Text("\(service.current)/\(service.duration)")
        }
    }
}

class TimelineService : Service {
    
    @ViewState fileprivate var current = "00:00:00"
    
    @ViewState fileprivate var duration = "00:00:00"
    
    private var cancellables = [AnyCancellable]()
    
    private var timeObserver: Any?
    
    required init(_ context: Context) {
        super.init(context)
        
        let renderService = context[RenderService.self]
        timeObserver = renderService.player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: nil) { [weak self] time in
            guard let self = self else { return }
            
            let current = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(renderService.player.currentItem!.duration)
            
            self.current = self.toDisplay(Int(current))
            self.duration = duration.isNormal ? self.toDisplay(Int(duration)) : "00:00:00"
        }
        
        let pluginService = context[PluginService.self]
        let viewSizeService = context[ViewSizeService.self]
        let gestureService = context[GestureService.self]
        gestureService.observe(.drag(.horizontal)) { [weak self] event in
            guard let self = self else { return }
            
            switch event.action {
            case .start:
                
                guard let item = renderService.player.currentItem else { return }
                guard item.duration.seconds.isNormal else { return }
                
                guard case let .drag(value) = event.value else { return }
                
                let percent = value.translation.width / viewSizeService.width
                let secs = item.duration.seconds * percent
                let current = item.currentTime().seconds
                pluginService.present(.center) {
                    Text(self.toDisplay(Int(current + secs)))
                        .padding(8)
                        .background(Color.white.opacity(0.5))
                        .offset(CGSize(width: 0, height: 50))
                }
            case .end:
                pluginService.dismiss()
                break
            }
        }.store(in: &cancellables)
    }
    
    private func toDisplay(_ seconds: Int) -> String {
        
        if seconds < 0 {
            return "00:00:00"
        }
        
        var hours = "", mins = "", secs = ""
        
        let numberOfHour = seconds / 3600
        if numberOfHour >= 10 {
            hours = "\(numberOfHour)"
        } else {
            hours = "0\(numberOfHour)"
        }
        
        let numberOfMin = (seconds % 3600) / 60
        if numberOfMin >= 10 {
            mins = "\(numberOfMin)"
        } else {
            mins = "0\(numberOfMin)"
        }
        
        let numberOfSec = (seconds % 3600) % 60
        if numberOfSec >= 10 {
            secs = "\(numberOfSec)"
        } else {
            secs = "0\(numberOfSec)"
        }
        
        return "\(hours):\(mins):\(secs)"
    }
}

