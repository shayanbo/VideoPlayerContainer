//
//  PlaybackService.swift
//  TikTok-Example
//
//  Created by shayanbo on 2023/6/30.
//

import Foundation
import SwiftUI
import Combine
import VideoPlayerContainer

class PlaybackService : Service {
    
    private var cancellables = [AnyCancellable]()
    
    required init(_ context: Context) {
        super.init(context)
        
        let gestureService = context[GestureService.self]
        let pluginService = context[PluginService.self]
        let player = context[RenderService.self].player
        
        gestureService.observe(.tap(.all)) { event in
            
            if player.rate == 0 {
                player.play()
                pluginService.dismiss()
            } else {
                player.pause()
                pluginService.present(.center, transition: .scale) {
                    Image(systemName: "play.fill").resizable()
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 50, height: 50).opacity(0.5)
                }
            }
            
        }.store(in: &cancellables)
    }
}
