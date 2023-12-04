//
//  PlayerWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/15.
//

import SwiftUI

/// Service used by ``PlayerWidget``
///
/// This service offers some configuration that applies on the PlayerWidget.
/// Developers can use this Service to enable or disable overlays and add custom overlays
///
public class PlayerService: Service {
    
    @ViewState fileprivate var overlayAfterRender:( ()->AnyView )?
    
    @ViewState fileprivate var overlayAfterFeature:( ()->AnyView )?
    
    @ViewState fileprivate var overlayAfterPlugin:( ()->AnyView )?
    
    @ViewState fileprivate var overlayAfterControl:( ()->AnyView )?
    
    @ViewState fileprivate var overlayAfterToast:( ()->AnyView )?
    
    @StateSync(serviceType: FeatureService.self, keyPath: \.$feature) fileprivate var feature
    
    @ViewState fileprivate var overlays = Overlay.allCases
    
    /// Reference used by other API like ``enable(overlays:)`` or ``configure(overlay:overlayGetter:)``
    public enum Overlay: CaseIterable {
        
        /// Reference to RenderWidget
        case render
        /// Reference to FeatureWidget
        case feature
        /// Reference to PluginWidget
        case plugin
        /// Reference to ControlWidget
        case control
        /// Reference to ToastWidget
        case toast
    }
    
    /// Enable only parts of the built-in overlays
    ///
    /// In default, all of built-in overlays will be added into PlayerWidget, users can call this method
    /// to remove some of them
    ///
    /// - Parameter overlays: ``Overlay`` set to added. Overlays not included in the set won't be added into the PlayerWidget
    ///
    public func enable(overlays: [Overlay]) {
        self.overlays = overlays
    }
    
    /// Add custom overlay
    ///
    /// - Parameter overlay: location of new overlay, the added overlay will be added above it.
    /// - Parameter overlayGetter: closure to return a overlay instance
    ///
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

/// Primary View of VideoPlayerContainer
///
/// It's the entry for the VideoPlayerContainer, when developers use this framework, the first thing is to create the PlayerWidget passed in Context instance and optional service types.
/// When created, it adds built-in overlay as needed [See: ``PlayerService/enable(overlays:)``] all of which play important roles. the Overlay is the widget container with different rules.
///
/// Responsibilities overview for built-in overlay:
/// 1. Render: control over the playback and render detail
/// 2. Feature: pop up a panel from 4 directions
/// 3. Plugin: like a graffiti wall, you can present any ``Widget`` with a specific location
/// 4. Control: this overlay is probably the place you have to pay more attention to, it displays Widgets at a fixed location, like Seekbar, PlaybackWidget and etc.
/// 5. Toast: fly in from the left edge and dismiss after few seconds, developers can use it to show some tips or warnings
///
/// Besides the built-in overlay, developers can insert custom overlay to extend the VideoPlayerContainer. See ``PlayerService/configure(overlay:overlayGetter:)``
///
public struct PlayerWidget: View {
    
    private weak var context: Context?
    
    /// Contructor for PlayerWidget
    ///
    /// - Parameter context: Context instance that's responsible for holding all of services.
    /// - Parameter launch: Optional Service Set needed to be created when PlayerWidget is created.
    /// - Returns: Instance of PlayerWidget
    /// - Attention:PlayerWidget is not responsible for maintaining Context lifecycle. developers should take on it. For example, take it as an @StateObject property in the enclosing View
    ///
    public init(_ context: Context, launch services: [Service.Type] = []) {
        self.context = context
        
        services.forEach { serviceType in
            let _ = context[serviceType]
        }
    }
    
    public var body: some View {
        
        GeometryReader { proxy in
            
            let _ = {
                context?.viewSize.updateViewSize(proxy.size)
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
        .environmentObject(context ?? Context())
        .coordinateSpace(name: CoordinateSpace.containerSpaceName)
        .onHover { changeOrEnd in
            context?.gesture.handleHover(action: changeOrEnd ? .start : .end)
        }
    }
}

public extension CoordinateSpace {
    
    fileprivate static var containerSpaceName: String {
        "PlayerWidget"
    }
    
    /// Container-wide coordinate space
    ///
    /// You can access widget's frame information in the whole VideoPlayerContainer by using it in GeometryProxy.frame(in:)
    static var containerSpace: CoordinateSpace {
        .named(containerSpaceName)
    }
}

public extension Context {
    
    /// Simple alternative for `context[PlayerService.self]`
    var container: PlayerService {
        self[PlayerService.self]
    }
}
