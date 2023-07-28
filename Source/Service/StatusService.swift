//
//  StatusService.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/20.
//

import Foundation

/// Non-Widget Service maintaining status of VideoPlayerContainer.
///
/// Status is the situation  of VideoPlayerContainer and is 100% decided by developers.
/// You can decide when and which status should be set. we offer 3 status: fullscreen, halfscreen, portrait.
///
/// Although you can refer to situation with any status.
/// In convention, we think it's **fullscreen** if interface orientation is landscape and video full up the screen;
/// It's **halfscreen** if the interface orientation is portrait, the video doesn't full up the screen and its width is great than height;
/// It's **portrait** if the interface orientation is portrait, the video doesn't full up the screen but its width is less than height
///
public class StatusService : Service {
    
    /// The situation  of VideoPlayerContainer.
    public enum Status {
        /// In convention, we think it's **halfscreen** if the interface orientation is portrait, the video doesn't full up the screen and its width is great than height;
        case halfScreen
        /// In convention, we think it's **fullscreen** if interface orientation is landscape and video full up the screen;
        case fullScreen
        /// In convention, we think it's **portrait** if the interface orientation is portrait, the video doesn't full up the screen but its width is less than height
        case portrait
    }
    
    @ViewState public private(set) var status: Status = .halfScreen
    
    /// A boolean value that indicates whether the status is fullscreen.
    public var isFullScreen: Bool {
        status == .fullScreen
    }
    
    /// A boolean value that indicates whether the status is halfscreen.
    public var isHalfScreen: Bool {
        status == .halfScreen
    }
    
    /// A boolean value that indicates whether the status is portrait.
    public var isPortrait: Bool {
        status == .portrait
    }
    
    /// Switch the status to fullscreen.
    public func toFullScreen() {
        status = .fullScreen
    }
    
    /// Switch the status to halfscreen.
    public func toHalfScreen() {
        status = .halfScreen
    }
    
    /// Switch the status to portrait.
    public func toPortrait() {
        status = .portrait
    }
}
