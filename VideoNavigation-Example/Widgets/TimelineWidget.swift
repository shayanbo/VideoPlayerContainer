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

struct CountdownWidget : View {
    
    var body: some View {
        
        WithService(CountdownWidgetService.self) { service in
            Text(service.current)
                .foregroundColor(.white)
                .font(.system(size: 12))
        }
    }
}

fileprivate class CountdownWidgetService : Service {
    
    @ViewState var current = "00:00"
    
    private var timeObserver: Any?
    
    required init(_ context: Context) {
        super.init(context)
        
        let renderService = context[RenderService.self]
        timeObserver = renderService.player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: nil) { [weak self] time in
            guard let self = self else { return }
            
            let current = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(renderService.player.currentItem!.duration)
            
            if duration.isNaN {
                self.current = "00:00"
            } else {
                self.current = self.toDisplay(Int(duration - current))
            }
        }
    }
    
    private func toDisplay(_ seconds: Int) -> String {
        
        if seconds < 0 {
            return "00:00"
        }
        
        var mins = "", secs = ""
        
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
        
        return "\(mins):\(secs)"
    }
}

