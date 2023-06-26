//
//  PlaybackWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/19.
//

import SwiftUI
import Combine
import VideoPlayerContainer

struct PlaybackButtonWidget : View {
    
    var body: some View {
        WithService(PlaybackButtonService.self) { service in
            Button {
                service.didClick()
            } label: {
                if service.playOrPaused {
                    Image(systemName: "pause.fill")
                        .frame(height:40)
                } else {
                    Image(systemName: "play.fill")
                        .frame(height:40)
                }
            }
        }
    }
}

class PlaybackButtonService: Service {
    
    private var rateObservation: NSKeyValueObservation?
    
    private var statusObservation: NSKeyValueObservation?
    
    private var cancellables = [AnyCancellable]()
    
    @ViewState fileprivate var playOrPaused = false
    
    @ViewState fileprivate var clickable = false
    
    required init(_ context: Context) {
        super.init(context)
        
        let service = context[RenderService.self]
        rateObservation = service.player.observe(\.rate, options: [.old, .new, .initial]) { [weak self] player, change in
            self?.playOrPaused = player.rate > 0
        }
        
        statusObservation = service.player.observe(\.status, options: [.old, .new, .initial]) { [weak self] player, change in
            self?.clickable = player.status == .readyToPlay
        }
        
        let gestureService = context[GestureService.self]
        gestureService.observeDoubleTap { [weak self] in
            self?.didClick()
        }.store(in: &cancellables)
    }
    
    fileprivate func didClick() {
        
        let service = context[RenderService.self]
        if service.player.rate == 0 {
            service.player.play()
        } else {
            service.player.pause()
        }
    }
}
