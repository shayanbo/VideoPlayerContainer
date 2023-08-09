//
//  PluginWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/19.
//

import SwiftUI
import Combine

/// Service used by PluginWidget.
///
/// Like a graffiti wall, you can present any ``Widget`` with a specific location.
/// 
public class PluginService : Service {
    
    fileprivate struct Plugin {
        let alignment: Alignment
        let transition: AnyTransition
        let content: ()->AnyView
    }
    
    /// The boolean value that indicates whether the plugin is presented
    public var isBeingPresented: Bool {
        plugin != nil
    }
    
    @ViewState fileprivate var plugin: Plugin?
    
    /// Present a plugin widget
    /// 
    /// - Parameter alignment: The guide for aligning the plugin on both the x- and y-axes.
    /// - Parameter animation: Animation applied on the plugin when presenting.
    /// - Parameter transition: Transition applied on the plugin when presenting and dismissing.
    /// - Parameter content: The view builder to create plugin widget.
    ///
    public func present(_ alignment: Alignment, animation: Animation? = .default, transition: AnyTransition = .opacity, content: @escaping ()-> AnyView) {
        withAnimation(animation) {
            self.plugin = Plugin(alignment: alignment, transition: transition, content: content)
        }
    }
    
    /// Dismiss the plugin widget.
    /// - Parameter animation: Animation applied on the plugin when dismissing.
    ///
    public func dismiss(animation: Animation? = .default) {
        withAnimation(animation) {
            self.plugin = nil
        }
    }
}

struct PluginWidget: View {
    var body: some View {
        WithService(PluginService.self) { service in
            
            ZStack(alignment: service.plugin?.alignment ?? .center) {
                Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if let plugin = service.plugin {
                    plugin.content()
                        .transition(plugin.transition)
                }
            }
        }
    }
}

public extension Context {
    
    /// Simple alternative for `context[PluginService.self]`
    var plugin: PluginService {
        self[PluginService.self]
    }
}
