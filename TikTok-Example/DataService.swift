//
//  DataService.swift
//  TikTok-Example
//
//  Created by shayanbo on 2023/7/16.
//

import Foundation
import VideoPlayerContainer

@dynamicMemberLookup
class DataService : Service {
    
    private var video: VideoData?
    
    func load(_ video: VideoData?) {
        self.video = video
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<VideoData, Value>) -> Value? {
        video?[keyPath: keyPath]
    }
}
