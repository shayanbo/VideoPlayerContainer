//
//  PlayerWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/15.
//

import SwiftUI

public class PlayerService: Service {
    
    @ViewState fileprivate var overlayAfterRender:( ()->any View )?
    @ViewState fileprivate var overlayAfterFeature:( ()->any View )?
    @ViewState fileprivate var overlayAfterPlugin:( ()->any View )?
    @ViewState fileprivate var overlayAfterControl:( ()->any View )?
    @ViewState fileprivate var overlayAfterToast:( ()->any View )?
    
    public enum Overlay {
        case render
        case feature
        case plugin
        case control
        case toast
    }
    
    public func configure(_ overlay: Overlay, overlayGetter: @escaping ()->some View) {
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
                    
                    if let overlay = service.overlayAfterRender {
                        AnyView(overlay())
                    }
                    
                    FeatureWidget()
                    
                    if let overlay = service.overlayAfterFeature {
                        AnyView(overlay())
                    }
                    
                    PluginWidget()
                    
                    if let overlay = service.overlayAfterPlugin {
                        AnyView(overlay())
                    }
                    
                    ControlWidget()
                    
                    if let overlay = service.overlayAfterControl {
                        AnyView(overlay())
                    }
                    
                    ToastWidget()
                    
                    if let overlay = service.overlayAfterToast {
                        AnyView(overlay())
                    }
                }
            }
        }
    }
}
