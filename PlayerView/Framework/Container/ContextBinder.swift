//
//  ContextBinder.swift
//  PlayerView
//
//  Created by shayanbo on 2023/6/23.
//

import Foundation
import SwiftUI

public struct ContextBinder: ViewModifier {
    
    let context: Context
    let services: [Service.Type]
    
    public func body(content: Content) -> some View {
        
        let _ = {
            services.forEach {
                let _ = context[$0]
            }
        }()
        
        content.environmentObject(context)
    }
}

public extension View {
    
    func bindContext(_ context: Context, launch services: [Service.Type] = []) -> some View {
        modifier(ContextBinder(context: context, services: services))
    }
}
