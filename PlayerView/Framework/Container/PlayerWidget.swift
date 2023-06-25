//
//  PlayerWidget.swift
//  PlayerView
//
//  Created by shayanbo on 2023/6/15.
//

import SwiftUI

public struct PlayerWidget: View {
    
    @EnvironmentObject private var context: Context
    
    public var body: some View {
        GeometryReader { proxy in
            
            let _ = {
                let service = context[ViewSizeService.self]
                service.updateViewSize(proxy.size)
            }()
            
            ZStack {
                RenderWidget()
                FeatureWidget()
                PluginWidget()
                ControlWidget()
                ToastWidget()
            }
            .onTapGesture(count: 2) {
                let service = context[GestureService.self]
                service.performDoubleTap()
            }
            .onTapGesture(count: 1) {
                let service = context[GestureService.self]
                service.performTap()
            }
            .gesture(
                DragGesture()
                    .onChanged{ value in
                        let service = context[GestureService.self]
                        service.performDrag(.changed(value))
                    }
                    .onEnded{ value in
                        let service = context[GestureService.self]
                        service.performDrag(.end(value))
                    }
            )
            .onLongPressGesture {
                } onPressingChanged: {
                    context[GestureService.self].performLongPress( $0 ? .start : .end)
            }

        }
    }
}
