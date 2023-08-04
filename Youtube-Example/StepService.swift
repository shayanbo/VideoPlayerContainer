//
//  StepService.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/7/9.
//

import Foundation
import VideoPlayerContainer
import Combine

class StepService : Service {
    
    private var cancellables = [AnyCancellable]()
    
    required init(_ context: Context) {
        super.init(context)
        
        context.gesture.observe(.doubleTap(.all)) { [weak context] event in
            guard let player = context?[RenderService.self].player else { return }
            
            switch event.gesture {
            case .doubleTap(.left):
                player.currentItem?.step(byCount: -30 * 5)
            case .doubleTap(.right):
                player.currentItem?.step(byCount: 30 * 5)
            default: break
            }
            
            player.play()
        }.store(in: &cancellables)
    }
}
