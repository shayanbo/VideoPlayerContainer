//
//  StepBackWidget.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/7/1.
//

import SwiftUI
import VideoPlayerContainer

fileprivate class StepBackwardWidgetService: Service {
    
    func stepBackward() {
        let player = context[RenderService.self].player
        player.currentItem?.step(byCount: -30 * 5)
        player.play()
    }
}

struct StepBackWidget: View {
    var body: some View {
        WithService(StepBackwardWidgetService.self) { service in
            Button {
                service.stepBackward()
            } label: {
                Image(systemName: "backward.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
            }
            .keyboardShortcut(.leftArrow, modifiers: [])
            .buttonStyle(.plain)
        }
    }
}
