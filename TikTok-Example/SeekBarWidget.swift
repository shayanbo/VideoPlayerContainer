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
        WithService(SeekBarService.self) { service in
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray)
                    .cornerRadius(2)
                GeometryReader { proxy in
                    Rectangle()
                        .fill(.white)
                        .frame(maxHeight: .infinity)
                        .frame(width: service.progress * proxy.size.width)
                }
            }
            .padding(.horizontal, 10)
            .frame(height: 5)
        }
    }
}

class SeekBarService : Service {
    
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
            
            self.progress = time.seconds / item.duration.seconds
            print(self.progress)
        }
    }
}
