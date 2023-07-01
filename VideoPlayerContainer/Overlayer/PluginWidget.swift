//
//  PluginWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/19.
//

import SwiftUI
import Combine

struct PluginWidget: View {
    var body: some View {
        WithService(PluginService.self) { service in
            
            ZStack(alignment: service.plugin?.alignment ?? .center) {
                Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if let plugin = service.plugin {
                    AnyView(plugin.content())
                        .transition(plugin.transition)
                }
            }
        }
    }
}

public class PluginService : Service {
    
    fileprivate struct Plugin {
        let alignment: Alignment
        let transition: AnyTransition
        let content: ()->any View
    }
    
    @ViewState fileprivate var plugin: Plugin?
    
    public func present(_ alignment: Alignment, animation: Animation? = .default, transition: AnyTransition = .opacity, content: @escaping ()-> some View) {
        withAnimation(animation) {
            self.plugin = Plugin(alignment: alignment, transition: transition, content: content)
        }
    }
    
    public func dismiss(animation: Animation? = .default) {
        withAnimation(animation) {
            self.plugin = nil
        }
    }
}
