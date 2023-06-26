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
            if let plugin = service.plugin {
                ZStack(alignment: plugin.alignment) {
                    AnyView(plugin.viewGetter())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

public class PluginService : Service {
    
    public struct Plugin {
        let alignment: Alignment
        let viewGetter: ()->any View
    }
    
    @ViewState fileprivate var plugin: Plugin?
    
    public func present(_ alignment: Alignment, viewGetter: @escaping ()-> some View) {
        self.plugin = Plugin(alignment: alignment, viewGetter: viewGetter)
    }
    
    public func dismiss() {
        self.plugin = nil
    }
}

