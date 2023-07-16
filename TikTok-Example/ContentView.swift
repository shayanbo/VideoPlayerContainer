//
//  ContentView.swift
//  TikTok-Example
//
//  Created by shayanbo on 2023/6/29.
//

import SwiftUI
import VideoPlayerContainer
import AVKit

struct VideoData: Hashable {
    
    let videoUrl: String
    let author: String
    let description: String
    let comments: [String]
    let id = UUID().uuidString
}

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
            context[RenderService.self].player.pause()
        }
    }
    
    func playCurrentVideo() {
        let index = Int(abs(base) / playerHeight)
        let video = videos[index]
        let context = findOrCreateContext(video)
        let player = context[RenderService.self].player
        let item = AVPlayerItem(url: URL(string: "file://\(video.videoUrl)")!)
        player.replaceCurrentItem(with: item)
        player.play()
    }
    
    private var playerHeight: CGFloat {
        let context = self.contexts.values.first!
        let height = context[ViewSizeService.self].height
        return height
    }
    
    func pauseCurrentVideo() {
        let index = Int(abs(base) / playerHeight)
        let video = videos[index]
        let context = findOrCreateContext(video)
        let player = context[RenderService.self].player
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

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    func playerView(_ video: VideoData) -> some View {
        
        PlayerWidget(viewModel.findOrCreateContext(video), launch: [PlaybackService.self])
            .onAppear {
                
                let context = viewModel.findOrCreateContext(video)
                let controlService = context[ControlService.self]
                
                context[StatusService.self].toPortrait()
                context[DataService.self].load(video)
                
                controlService.configure(displayStyle: .always)
                
                controlService.configure(.portrait(.top), shadow: nil)
                controlService.configure(.portrait(.bottom), shadow: nil)
                
                controlService.configure(.portrait, insets: .init(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                controlService.configure(.portrait(.bottom1)) {[
                    SeekBarWidget()
                ]}
                
                controlService.configure(.portrait(.right)) { views in
                    VStack(spacing: 20) {
                        ForEach(views) { $0 }
                    }
                }
                
                controlService.configure(.portrait(.center)) {[
                    Spacer().frame(width: 50)
                ]}
                
                controlService.configure(.portrait(.right)) {[
                    Spacer(),
                    Image(systemName: "person.fill.badge.plus").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30),
                    Image(systemName: "heart.fill").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30),
                    MessageWidget(),
                    Image(systemName: "star.fill").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30),
                    Image(systemName: "arrowshape.turn.up.right.fill").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30),
                    Image(systemName: "circle.fill").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30),
                    Spacer().frame(height: 0),
                ]}
                
                controlService.configure(.portrait(.left)) { views in
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(views) { $0 }
                    }
                }
                
                controlService.configure(.portrait(.left)) {[
                    Spacer(),
                    TitleWidget(),
                    DescriptionWidget(),
                    Spacer().frame(height: 0),
                ]}
                
                context[FeatureService.self].configure(dismissOnClick: true)
                
                controlService.configure(.portrait(.left), transition: .opacity)
                controlService.configure(.portrait(.right), transition: .opacity)
                
                controlService.configure(displayStyle: .custom(animation: .default))
                controlService.present()
                
                context[RenderService.self].fit()
                
                context[GestureService.self].simultaneousDragGesture = viewModel.dragGesture
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var feeds: some View {
        
        GeometryReader { proxy in
            LazyVStack(spacing:0) {
                ForEach(viewModel.videos, id: \.self) { video in
                    playerView(video)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .offset(CGSize(width: 0, height: viewModel.base + viewModel.offset))
                }
            }
            .gesture(viewModel.dragGesture)
            .onAppear {
                viewModel.playCurrentVideo()
            }
            .onDisappear {
                viewModel.pauseCurrentVideo()
            }
        }
        .background(.black)
        .clipped()
        .ignoresSafeArea(edges: .top)
    }
    
    var body: some View {
        
        TabView {
            
            feeds
                .tabItem {
                    Label("Home", systemImage: "house.circle.fill")
                }
            
            Text("Second Page")
                .tabItem {
                    Label("Friends", systemImage: "link.circle.fill")
                }
            
            Text("Third Page")
                .tabItem {
                    Label("Message", systemImage: "message.circle.fill")
                }
            
            Text("Forth Page")
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
