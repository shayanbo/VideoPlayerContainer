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

fileprivate class DurationWidgetService : Service {
    
    @ViewState var duration = "00:00"
    
    private var timeObserver: Any?
    
    required init(_ context: Context) {
        super.init(context)
        
        timeObserver = context.render.player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: nil) { [weak self, weak context] time in
            guard let self, let context else { return }
            
            let duration = CMTimeGetSeconds(context.render.player.currentItem!.duration)
            self.duration = duration.isNormal ? self.toDisplay(Int(duration)) : "00:00"
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

struct DurationWidget : View {
    
    var body: some View {
        WithService(DurationWidgetService.self) { service in
            Text(service.duration)
                .font(.system(size:12))
                .foregroundColor(.white)
                .opacity(0.7)
        }
    }
}
