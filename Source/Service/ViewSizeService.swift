//
//  ViewSizeService.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/19.
//

import Foundation

/// Non-Widget Service maintaining size of VideoPlayerContainer.
public class ViewSizeService : Service {
    
    private(set) var size = CGSize.zero
    
    /// Width of VideoPlayerContainer.
    public var width: Double {
        size.width
    }
    
    /// Height of VideoPlayerContainer.
    public var height: Double {
        size.height
    }
    
    func updateViewSize(_ size: CGSize) {
        self.size = size
    }
}

public extension Context {
    
    /// Simple alternative for `context[ViewSizeService.self]`
    var viewSize: ViewSizeService {
        self[ViewSizeService.self]
    }
}
