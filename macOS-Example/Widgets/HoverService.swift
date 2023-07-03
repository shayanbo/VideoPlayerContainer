//
//  HoverService.swift
//  macOS-Example
//
//  Created by shayanbo on 2023/7/3.
//

import Foundation
import Combine
import VideoPlayerContainer

class HoverService : Service {
    
    private var cancellables = [AnyCancellable]()
    
    required init(_ context: Context) {
        super.init(context)
        
        context[GestureService.self].observe(.hover) { event in
            
            if event.action == .start {
                context[ControlService.self].present()
            } else {
                context[ControlService.self].dismiss()
            }
        }.store(in: &cancellables)
    }
}
