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
        
        /// put WithService inside the GeometryReader
        GeometryReader { proxy in
            WithService(SeekBarWidgetService.self) { service in
            
                ZStack(alignment: .leading) {
                    Rectangle().fill(.gray)
                    
                    Rectangle().fill(.red)
                        .frame(maxHeight: .infinity)
                        .frame(width: service.progress * proxy.size.width)
                }
                .cornerRadius(1)
            }
        }
        .frame(height: 3)
    }
}

fileprivate class SeekBarWidgetService : Service {
    
    @ViewState var progress = 0.0
    
    private var timeObserver: Any?
    
    required init(_ context: Context) {
        super.init(context)
        
        timeObserver = context.render.player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: nil) { [weak self, weak context] time in
            guard let self, let context else { return }
            guard let item = context.render.player.currentItem else { return }
            guard item.duration.seconds.isNormal else { return }
            
            self.progress = time.seconds / item.duration.seconds
        }
    }
}
