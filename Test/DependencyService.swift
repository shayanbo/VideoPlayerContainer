//
//  DependencyService.swift
//  VideoPlayerContainerTests
//
//  Created by shayanbo on 2023/8/8.
//

import Foundation
import VideoPlayerContainer

class DependencyService: Service {
    
    func fetchData() -> UInt64 {
        var generator = SystemRandomNumberGenerator()
        return generator.next()
    }
}
