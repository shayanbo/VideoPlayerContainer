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
        }
    }
}
