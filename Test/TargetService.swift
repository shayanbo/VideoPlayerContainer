//
//  SampleService.swift
//  VideoPlayerContainerTests
//
//  Created by shayanbo on 2023/8/8.
//

import Foundation
import VideoPlayerContainer

class TargetService: Service {
    
    func fetchDataFromDependency() -> UInt64 {
        context[DependencyService.self].fetchData()
    }
}
