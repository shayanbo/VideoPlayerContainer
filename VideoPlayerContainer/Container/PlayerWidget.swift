//
//  PlayerWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/15.
//

import SwiftUI

public class PlayerService: Service {
    
    @ViewState fileprivate var overlayAfterRender:( ()->AnyView )?
    @ViewState fileprivate var overlayAfterFeature:( ()->AnyView )?
    @ViewState fileprivate var overlayAfterPlugin:( ()->AnyView )?
    @ViewState fileprivate var overlayAfterControl:( ()->AnyView )?
    @ViewState fileprivate var overlayAfterToast:( ()->AnyView )?
    
    public enum Overlay {
        case render
        case feature
        case plugin
        case control
        case toast
    }
    
    public func configure(_ overlay: Overlay, overlayGetter: @escaping ()->AnyView) {
        switch overlay {
        case .render:
            overlayAfterRender = overlayGetter
        case .feature:
            overlayAfterFeature = overlayGetter
        case .plugin:
            overlayAfterPlugin = overlayGetter
        case .control:
            overlayAfterControl = overlayGetter
        case .toast:
            overlayAfterToast = overlayGetter
        }
    }
}

public struct PlayerWidget: View {
    
    public init() {}
    
    @EnvironmentObject private var context: Context
    
    public var body: some View {
        WithService(PlayerService.self) { service in
            GeometryReader { proxy in
                
                let _ = {
                    let service = context[ViewSizeService.self]
                    service.updateViewSize(proxy.size)
                }()
                
                ZStack {
                    RenderWidget()
                    service.overlayAfterRender?()
                    FeatureWidget()
                    service.overlayAfterFeature?()
                    PluginWidget()
                    service.overlayAfterPlugin?()
                    ControlWidget()
                    service.overlayAfterControl?()
                    ToastWidget()
                    service.overlayAfterToast?()
                }
            }
        }
    }
}
