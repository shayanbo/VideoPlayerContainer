//
//  StepForwardWidget.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/7/1.
//

import SwiftUI
import VideoPlayerContainer

fileprivate class StepForwardWidgetService: Service {
    
    private var observation: NSKeyValueObservation?
    
    @ViewState var enabled = false
        
    required init(_ context: Context) {
        super.init(context)
        
        observation = context.render.player.observe(\.currentItem) { [weak self] player, changes in
            guard let item = player.currentItem else { return }
            self?.enabled = item.canStepForward
        }
    }
    
    func stepForward() {
        context?.render.player.currentItem?.step(byCount: 30 * 5)
        context?.render.player.play()
    }
}

struct StepForwardWidget: View {
    var body: some View {
        WithService(StepForwardWidgetService.self) { service in
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
