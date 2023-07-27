//
//  FramePreferenceKey.swift
//  VideoNavigation-Example
//
//  Created by shayanbo on 2023/7/22.
//

import SwiftUI

struct VideoFrame : Equatable {
    let video: Video
    let frame: CGRect
}

struct VideoFramePreferenceKey: PreferenceKey {
    
    static var defaultValue: [VideoFrame] {
        []
    }
    
    static func reduce(value: inout [VideoFrame], nextValue: () -> [VideoFrame]) {
        value += nextValue()
    }
}

extension View {
    func videoFrameProvider(video: Video, frame: CGRect) -> some View {
        preference(
            key:VideoFramePreferenceKey.self,
            value: [
                VideoFrame(video: video, frame: frame)
            ]
        )
    }
}
