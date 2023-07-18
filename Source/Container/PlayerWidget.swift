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
    
    @StateSync(serviceType: FeatureService.self, keyPath: \.$feature) fileprivate var feature
    
    @ViewState fileprivate var overlays = Overlay.allCases
    
    public enum Overlay: CaseIterable {
        case render, feature, plugin, control, toast
    }
    
    public func enable(overlays: [Overlay]) {
        self.overlays = overlays
    }
    
    public func configure(overlay: Overlay, overlayGetter: @escaping ()-> AnyView) {
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
    
    private let context: Context
    
    public init(_ context: Context, launch services: [Service.Type] = []) {
        self.context = context
        
        services.forEach { serviceType in
            let _ = context[serviceType]
        }
    }
    
    public var body: some View {
        
        GeometryReader { proxy in
            
            let _ = {
                let service = context[ViewSizeService.self]
                service.updateViewSize(proxy.size)
            }()
            
            WithService(PlayerService.self) { service in
                
                HStack {
                    
                    if let feature = service.feature, case let .left(.squeeze(spacing)) = feature.direction {
                        
                        AnyView(
                            feature.content()
                                .frame(maxHeight: .infinity)
                                .transition(.move(edge: .leading))
                        )
                        
                        Spacer().frame(width: spacing)
                    }
                    
                    VStack {
                        
                        if let feature = service.feature, case let .top(.squeeze(spacing)) = feature.direction {
                            
                            AnyView(
                                feature.content()
                                    .frame(maxWidth: .infinity)
                                    .transition(.move(edge: .top))
                            )
                            
                            Spacer().frame(height: spacing)
                        }
                        
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
                        
                        if let feature = service.feature, case let .bottom(.squeeze(spacing)) = feature.direction {
                            
                            Spacer().frame(height: spacing)
                            
                            AnyView(
                                feature.content()
                                    .frame(maxWidth: .infinity)
                                    .transition(.move(edge: .bottom))
                            )
                        }
                    }
                    
                    if let feature = service.feature, case let .right(.squeeze(spacing)) = feature.direction {
                        
                        Spacer().frame(width: spacing)
                        
                        AnyView(
                            feature.content()
                                .frame(maxHeight: .infinity)
                                .transition(.move(edge: .trailing))
                        )
                    }
                }
                .clipped()
            }
        }
        .environmentObject(context)
        .onHover { changeOrEnd in
            context[GestureService.self].handleHover(action: changeOrEnd ? .start : .end)
        }
    }
}
