//
//  ContentView.swift
//  TikTok-Example
//
//  Created by shayanbo on 2023/6/29.
//

import SwiftUI
import VideoPlayerContainer
import AVKit

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
                
                context[RenderService.self].layer.videoGravity = .resizeAspect
                
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
