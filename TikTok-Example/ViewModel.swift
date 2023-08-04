//
//  ViewModel.swift
//  TikTok-Example
//
//  Created by shayanbo on 2023/7/26.
//

import Combine
import VideoPlayerContainer
import AVKit
import SwiftUI

class ViewModel: ObservableObject {
    
    var contexts = [String: Context]()
    var videos = mockedVideos
    
    @Published var offset = 0.0
    @Published var base = 0.0
    
    func findOrCreateContext(_ video: VideoData) -> Context {
        if let context = contexts[video.id] {
            return context
        }
        let context = Context()
        contexts[video.id] = context
        return context
    }
    
    func pausePreviousVideo() {
        self.contexts.values.forEach { context in
            context.render.player.pause()
        }
    }
    
    func playCurrentVideo() {
        let index = Int(abs(base) / playerHeight)
        let video = videos[index]
        let context = findOrCreateContext(video)
        let player = context.render.player
        let item = AVPlayerItem(url: URL(string: "file://\(video.videoUrl)")!)
        player.replaceCurrentItem(with: item)
        player.play()
    }
    
    private var playerHeight: CGFloat {
        let context = self.contexts.values.first!
        return context.viewSize.height
    }
    
    func pauseCurrentVideo() {
        let index = Int(abs(base) / playerHeight)
        let video = videos[index]
        let context = findOrCreateContext(video)
        let player = context.render.player
        let item = AVPlayerItem(url: URL(string: "file://\(video.videoUrl)")!)
        player.replaceCurrentItem(with: item)
        player.pause()
    }
    
    private(set) lazy var dragGesture = DragGesture(coordinateSpace: .global)
        .onChanged { value in
            
            let swipeDown = value.translation.height > 0
            let first = self.base == 0
            let last = abs(Int(self.base / self.playerHeight)) == (self.videos.count - 1)
            
            if swipeDown && first || !swipeDown && last {
                return
            }
            
            self.offset = value.translation.height
        }
        .onEnded { value in
            
            let over = abs(value.translation.height) > self.playerHeight * 0.3
            let swipeDown = value.translation.height > 0
            
            let first = self.base == 0
            let last = abs(Int(self.base / self.playerHeight)) == (self.videos.count - 1)
            
            if swipeDown && first || !swipeDown && last {
                return
            }
            
            withAnimation(.easeInOut(duration: 0.1)) {
                self.offset = 0
                if over {
                    if swipeDown {
                        self.base += self.playerHeight
                    } else {
                        self.base -= self.playerHeight
                    }
                }
            }
            
            if over {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    self.pausePreviousVideo()
                    self.playCurrentVideo()
                }
            }
        }
}
