//
//  StepForwardWidget.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/7/1.
//

import SwiftUI
import VideoPlayerContainer

fileprivate class StepForwardWidgetService: Service {
    
    func stepForward() {
        let player = context[RenderService.self].player
        player.currentItem?.step(byCount: 30 * 5)
        player.play()
    }
}

struct StepForwardWidget: View {
    var body: some View {
        WithService(StepForwardWidgetService.self) { service in
            Button {
                service.stepForward()
            } label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.rightArrow, modifiers: [])
        }
    }
}
