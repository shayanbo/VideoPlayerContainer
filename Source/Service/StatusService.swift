//
//  StatusService.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/20.
//

import Foundation

public class StatusService : Service {
    
    public enum Status {
        case halfScreen
        case fullScreen
        case portrait
    }
    
    @ViewState public private(set) var status: Status = .halfScreen
    
    public var isFullScreen: Bool {
        status == .fullScreen
    }
    
    public var isHalfScreen: Bool {
        status == .halfScreen
    }
    
    public var isPortrait: Bool {
        status == .portrait
    }
    
    public func toFullScreen() {
        status = .fullScreen
    }
    
    public func toHalfScreen() {
        status = .halfScreen
    }
    
    public func toPortrait() {
        status = .portrait
    }
}
