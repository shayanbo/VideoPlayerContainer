//
//  VideoPlayerContainerTests.swift
//  VideoPlayerContainerTests
//
//  Created by shayanbo on 2023/8/8.
//

import XCTest
@testable import VideoPlayerContainer

final class Tests: XCTestCase {

    func testExample() throws {
        
        let context = TestContext()
        
        context.register(TargetService.self) {
            return TargetService($0)
        }
        
        let target = context[TargetService.self]
        XCTAssertEqual(target.fetchDataFromDependency(), 10)
    }
}
