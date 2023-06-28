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
    
    @StateSync(serviceType: FeatureService.self, keyPath: \.$feature) fileprivate var feature
    
    @ViewState fileprivate var overlays = Overlay.allCases
    
    public enum Overlay: CaseIterable {
        case render, feature, plugin, control, toast
    }
    
    public func enable(overlays: [Overlay]) {
        self.overlays = overlays
    }
    
    public func configure(overlay: Overlay, overlayGetter: @escaping ()->some View) {
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
            
            HStack {
                if let feature = service.feature, case .left(.squeeze) = feature.direction {
                    AnyView(
                        feature.viewGetter()
                            .frame(maxHeight: .infinity)
                            .transition(.move(edge: .leading))
                    )
                }
                
                if let feature = service.feature, case let .left(.squeeze(spacing)) = feature.direction {
                    Spacer().frame(width: spacing)
                }
                
                VStack {
                    
                    if let feature = service.feature, case .top(.squeeze) = feature.direction {
                        AnyView(
                            feature.viewGetter()
                                .frame(maxWidth: .infinity)
                                .transition(.move(edge: .bottom))
                        )
                    }
                    
                    if let feature = service.feature, case let .top(.squeeze(spacing)) = feature.direction {
                        Spacer().frame(height: spacing)
                    }
                    
                    GeometryReader { proxy in
                        
                        let _ = {
                            let service = context[ViewSizeService.self]
                            service.updateViewSize(proxy.size)
                        }()
                        
                        ZStack {
                            
                            if service.overlays.contains(.render) {
                                RenderWidget()
                            }
                            
                            if let overlay = service.overlayAfterRender {
                                AnyView(overlay())
                            }
                            
                            if service.overlays.contains(.feature) {
                                FeatureWidget()
                            }
                            
                            if let overlay = service.overlayAfterFeature {
                                AnyView(overlay())
                            }
                            
                            if service.overlays.contains(.plugin) {
                                PluginWidget()
                            }
                            
                            if let overlay = service.overlayAfterPlugin {
                                AnyView(overlay())
                            }
                            
                            if service.overlays.contains(.control) {
                                ControlWidget()
                            }
                            
                            if let overlay = service.overlayAfterControl {
                                AnyView(overlay())
                            }
                            
                            if service.overlays.contains(.toast) {
                                ToastWidget()
                            }
                            
                            if let overlay = service.overlayAfterToast {
                                AnyView(overlay())
                            }
                        }
                    }
                    
                    if let feature = service.feature, case let .bottom(.squeeze(spacing)) = feature.direction {
                        Spacer().frame(height: spacing)
                    }
                    
                    if let feature = service.feature, case .bottom(.squeeze) = feature.direction {
                        AnyView(
                            feature.viewGetter()
                                .frame(maxWidth: .infinity)
                                .transition(.move(edge: .top))
                        )
                    }
                }
                
                if let feature = service.feature, case let .right(.squeeze(spacing)) = feature.direction {
                    Spacer().frame(width: spacing)
                }
                
                if let feature = service.feature, case .right(.squeeze) = feature.direction {
                    AnyView(
                        feature.viewGetter()
                            .frame(maxHeight: .infinity)
                            .transition(.move(edge: .trailing))
                    )
                }
            }
            .clipped()
        }
    }
}
