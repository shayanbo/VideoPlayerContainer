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

struct DurationWidget : View {
    
    var body: some View {
        
        WithService(DurationWidgetService.self) { service in
            Text(service.duration)
                .foregroundColor(.white)
                .opacity(0.5)
        }
    }
}

class DurationWidgetService : Service {
    
    @ViewState fileprivate var duration = "00:00"
    
    private var cancellables = [AnyCancellable]()
    
    private var timeObserver: Any?
    
    required init(_ context: Context) {
        super.init(context)
        
        let renderService = context[RenderService.self]
        timeObserver = renderService.player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: nil) { [weak self] time in
            guard let self = self else { return }
            
            let duration = CMTimeGetSeconds(renderService.player.currentItem!.duration)
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

