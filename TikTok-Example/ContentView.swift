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
    
    /// create ViewModel and let it have the same lifecycle with its enclosing underlying view
    /// ViewModel holds Context instance for each video data, making them independent each other
    @StateObject var viewModel = ViewModel()
    
    func playerView(_ video: VideoData) -> some View {
        
        /// fetch the corresponding context from the viewModel by the video data
        /// launch PlaybackService.
        /// services in the launch parameters will be created at the beginning, we can do some task in the constructor of service
        PlayerWidget(viewModel.findOrCreateContext(video), launch: [PlaybackService.self])
            .onAppear {
                
                /// hold the reference to the Context, we need to use it frequently below
                let context = viewModel.findOrCreateContext(video)
                
                /// hold the reference to the ControlService, we need to use it frequently below
                let controlService = context[ControlService.self]
                
                /// take Portrait as the initial status, so we can see the portrait-related widgets inside the Control overlay
                context[StatusService.self].toPortrait()
                
                /// setup DataService with data, DataService is the data provider, other service can fetch original data from it
                context[DataService.self].load(video)
                
                /// make the Control overlay alway presented. not respond to the tap action
                controlService.configure(displayStyle: .always)
                
                /// remove default shadow for Portrait's top & bottom
                controlService.configure([.portrait(.top), .portrait(.bottom)], shadow: nil)
                
                /// setup insets for the whole Control overlay, since we would like to leave some space at the edges to make it looks better
                controlService.configure(.portrait, insets: .init(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                controlService.configure(.portrait(.bottom1)) {[
                    SeekBarWidget()
                ]}
                
                /// customize right side layout for portrait status
                controlService.configure(.portrait(.right)) { views in
                    VStack(spacing: 20) {
                        ForEach(views) { $0 }
                    }
                }
                
                /// widgets for center in portrait status
                /// the spacer here is used to separate left and right, since there's a Text at the left side without specifying its width.
                /// the left and right side would next to each other
                controlService.configure(.portrait(.center)) {[
                    SpacerWidget(width: 50)
                ]}
                
                /// widgets for right side in portrait status
                controlService.configure(.portrait(.right)) {[
                    SpacerWidget(),
                    ProfileWidget(),
                    LikeWidget(),
                    MessageWidget(),
                    FavorWidget(),
                    ShareWidget(),
                    AlbumWidget(),
                    SpacerWidget(height: 0)
                ]}
                
                /// customize the center layout for portrait
                controlService.configure(.portrait(.left)) { views in
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(views) { $0 }
                    }
                }
                
                /// widgets for left side in portrait status
                controlService.configure(.portrait(.left)) {[
                    SpacerWidget(),
                    TitleWidget(),
                    DescriptionWidget(),
                    SpacerWidget(height: 0)
                ]}
                
                /// setup show/dismiss transition for Portrait's top & bottom
                controlService.configure([.portrait(.left), .portrait(.right)], transition: .opacity)
                
                /// make the Control overlay only able to hide or show by calling API
                controlService.configure(displayStyle: .custom(animation: .default))
                
                /// make the Control overlay presented
                controlService.present()
                
                /// adjust the video render view's content mode to aspectFit
                context[RenderService.self].layer.videoGravity = .resizeAspect
                
                /// we encourage developers to use the simultaneous-related API to add gesture over the whole VideoPlayerContainer
                /// here, we add drag gesture to swipe up and down the feeds view
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
