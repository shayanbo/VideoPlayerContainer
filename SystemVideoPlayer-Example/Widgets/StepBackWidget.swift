//
//  StepBackWidget.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/7/1.
//

import SwiftUI
import VideoPlayerContainer

fileprivate class StepBackwardWidgetService: Service {
    
    private var observation: NSKeyValueObservation?
    
    @ViewState var enabled = false
        
    required init(_ context: Context) {
        super.init(context)
        
        observation = context.render.player.observe(\.currentItem) { [weak self] player, changes in
            guard let item = player.currentItem else { return }
            self?.enabled = item.canStepBackward
        }
    }
    
    func stepBackward() {
        context?.render.player.currentItem?.step(byCount: -30 * 5)
        context?.render.player.play()
    }
}

struct StepBackWidget: View {
    var body: some View {
        WithService(StepBackwardWidgetService.self) { service in
            Image(systemName: "gobackward.10")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .disabled(!service.enabled)
                .onTapGesture {
                    service.stepBackward()
                }
        }
    }
}
