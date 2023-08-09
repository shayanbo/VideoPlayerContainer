//
//  SampleService.swift
//  Test-Example
//
//  Created by shayanbo on 2023/8/9.
//

import Foundation
import VideoPlayerContainer

class TargetService: Service {
    
    @Dependency(\.numberClient) var numberClient
    
    func fetchData() async throws -> Int {
        try await numberClient.fetch()
    }
}

struct NumberClient {
    var fetch: () async throws -> Int
}

extension DependencyValues {
    
    var numberClient: NumberClient {
        NumberClient {
            let (data, _) = try await URLSession.shared.data(from: URL(string:"http://numbersapi.com/random/trivia")!)
            let str = String(data: data, encoding: .utf8)
            return Int(str?.components(separatedBy: " ").first ?? "") ?? 0
        }
    }
}
