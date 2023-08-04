//
//  PlaybackWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/19.
//

import SwiftUI
import Combine
import VideoPlayerContainer

fileprivate class PlaybackButtonService: Service {
    
    private var rateObservation: NSKeyValueObservation?
    
    private var statusObservation: NSKeyValueObservation?
    
    private var cancellables = [AnyCancellable]()
    
    @ViewState var playOrPaused = false
    
    @ViewState var clickable = false
    
    required init(_ context: Context) {
        super.init(context)
        
        rateObservation = context.render.player.observe(\.rate, options: [.old, .new, .initial]) { [weak self] player, change in
            self?.playOrPaused = player.rate > 0
        }
        
        statusObservation = context.render.player.observe(\.status, options: [.old, .new, .initial]) { [weak self] player, change in
            self?.clickable = player.status == .readyToPlay
        }
        
        context.gesture.observe(.doubleTap(.all)) { [weak self] _ in
            self?.didClick()
        }.store(in: &cancellables)
    }
    
    func didClick() {
        if context.render.player.rate == 0 {
            context.render.player.play()
        } else {
            context.render.player.pause()
        }
    }
}

struct PlaybackButtonWidget : View {
    
    var body: some View {
        WithService(PlaybackButtonService.self) { service in
            Button {
                service.didClick()
            } label: {
                if service.playOrPaused {
                    Image(systemName: "pause.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.space, modifiers: [])
        }
    }
}
