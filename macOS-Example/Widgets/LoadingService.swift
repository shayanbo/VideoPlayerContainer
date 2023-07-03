//
//  LoadingService.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/25.
//

import Foundation
import SwiftUI
import VideoPlayerContainer

class LoadingService : Service {
    
    private var status: NSKeyValueObservation?
    
    required init(_ context: Context) {
        super.init(context)
        
        status = context[RenderService.self].player.observe(\.timeControlStatus) { player, change in
            if player.timeControlStatus == .waitingToPlayAtSpecifiedRate {
                context[PluginService.self].present(.center) {
                    AnyView(
                        ProgressView()
                            .allowsHitTesting(false)
                    )
                }
            } else {
                context[PluginService.self].dismiss()
            }
        }
    }
}
