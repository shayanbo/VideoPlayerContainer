//
//  VideoPlayerContainerTests.swift
//  VideoPlayerContainerTests
//
//  Created by shayanbo on 2023/8/8.
//

import XCTest
import Mockingbird
@testable import VideoPlayerContainer

final class Tests: XCTestCase {

    func testExample() throws {
        
        let context = TestContext()
        
        context.register(TargetService.self) {
            TargetService($0)
        }
        
        context.register(DependencyService.self) {
            let target = mock(DependencyService.self).initialize($0)
            givenSwift(target.fetchData()) ~> { 10 }
            return target
        }
        
        let target = context[TargetService.self]
        XCTAssertEqual(target.fetchDataFromDependency(), 10)
    }
}
