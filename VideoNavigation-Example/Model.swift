//
//  MockData.swift
//  VideoNavigation-Example
//
//  Created by shayanbo on 2023/7/21.
//

import Foundation

struct Video : Codable, Hashable {
    let videoId : Int
    let avatarUrl: String
    let author: String
    let date: String
    let desc: String
    let likes: Int
    let comments: Int
    let favors: Int
    let shares: Int
    let topComment: Comment
}

extension Video : Identifiable {
    var id : Int {
        videoId
    }
}

struct Comment : Codable, Hashable {
    let avatarUrl: String
    let author: String
    let comment: String
    let likes: Int
}
