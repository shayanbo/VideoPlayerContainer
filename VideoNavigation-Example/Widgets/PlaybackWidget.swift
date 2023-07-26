//
//  PlaybackWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/19.
//

import SwiftUI
import Combine
import VideoPlayerContainer

class PlaybackWidgetService: Service {
    
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
        gestureService.observe(.doubleTap(.all)) { [weak self] _ in
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

struct PlaybackWidget : View {
    
    var body: some View {
        WithService(PlaybackWidgetService.self) { service in
            Group {
                if service.playOrPaused {
                    Image(systemName: "pause.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }
            }
            .onTapGesture {
                service.didClick()
            }
        }
    }
}
