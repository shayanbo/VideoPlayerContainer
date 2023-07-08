//
//  StepForwardWidget.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/7/1.
//

import SwiftUI
import VideoPlayerContainer

class StepForwardService: Service {
    
    private var observation: NSKeyValueObservation?
    
    @ViewState fileprivate var enabled = false
        
    required init(_ context: Context) {
        super.init(context)
        
        let player = context[RenderService.self].player
        observation = player.observe(\.currentItem) { [weak self] player, changes in
            guard let item = player.currentItem else { return }
            self?.enabled = item.canStepForward
        }
    }
    
    fileprivate func stepForward() {
        let player = context[RenderService.self].player
        player.currentItem?.step(byCount: 30 * 5)
        player.play()
    }
}

struct StepForwardWidget: View {
    var body: some View {
        WithService(StepForwardService.self) { service in
            Image(systemName: "forward.end.circle")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .disabled(!service.enabled)
                .onTapGesture {
                    service.stepForward()
                }
        }
    }
}
