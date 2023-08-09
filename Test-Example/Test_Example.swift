//
//  Test_Example.swift
//  Test-Example
//
//  Created by shayanbo on 2023/8/9.
//

import XCTest
@testable import VideoPlayerContainer

final class Test_Example: XCTestCase {

    func testExample() async throws {
        
        let context = Context()
        let target = context[TargetService.self]
        
        context.withDependency(\.numberClient) {
            NumberClient { 10 }
        }
        
        let value = try await target.fetchData()
        XCTAssertEqual(value, 10)
    }
}
