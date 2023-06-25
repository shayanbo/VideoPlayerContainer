//
//  ViewSizeService.swift
//  PlayerView
//
//  Created by shayanbo on 2023/6/19.
//

import Foundation

public class ViewSizeService : Service {
    
    private(set) var size = CGSize.zero
    
    public var width: Double {
        size.width
    }
    
    public var height: Double {
        size.height
    }
    
    public func updateViewSize(_ size: CGSize) {
        self.size = size
    }
}
