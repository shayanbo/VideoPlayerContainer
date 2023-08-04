//
//  ContentView.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/6/29.
//

import SwiftUI
import AVKit
import VideoPlayerContainer

struct ContentView: View {
    
    /// create Context and let it have the same lifecycle with its enclosing underlying view
    @StateObject var context = Context()
    
    /// we need hold the orientation as @State to update the whole UI when it changes
    @State var orientation = UIDevice.current.orientation
    
    var body: some View {
        
        GeometryReader { proxy in
            VStack {
                PlayerWidget(context, launch: [StepService.self])
                    .frame(maxHeight: orientation.isLandscape ? .infinity : proxy.size.width * 0.5625)
                    /// background modifier will cover the top safe area which make the VideoPlayerContainer looks better
                    .background(.black)
                    /// observe the device orientation and update status accordingly
                    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: { _ in
                        self.orientation = UIDevice.current.orientation
                        
                        if UIDevice.current.orientation.isLandscape {
                            /// update the status to Fullscreen, it will trigger the Control overlay UI updates. removing the portrait widgets and present fullscreen widgets
                            context.status.toFullScreen()
                        } else {
                            /// update the status to Portrait, it will trigger the Control overlay UI updates. removing the fullscreen widgets and present portrait widgets
                            context.status.toHalfScreen()
                        }
                    })
                    .onAppear {
                        
                        /// remove default shadow for Portrait's top & bottom and Fullscreen's top & bottom
                        context.control.configure([
                            .halfScreen(.top), .halfScreen(.bottom),
                            .fullScreen(.top), .fullScreen(.bottom),
                        ], shadow: nil)
                        
                        /// add a shadow covering the whole Control overlay
                        context.control.configure(shadow: AnyView(
                            Rectangle().fill(.black.opacity(0.2)).allowsHitTesting(false)
                        ))
                        
                        /// setup show/dismiss transition for Fullscreen's top & bottom and Halfscreen's top & bottom
                        context.control.configure([
                            .halfScreen(.top), .halfScreen(.bottom),
                            .fullScreen(.top), .fullScreen(.bottom),
                        ], transition: .opacity)
                        
                        /// setup insets for the whole Control overlay, since we would like to leave some space at the edges to make it looks better
                        context.control.configure(.halfScreen, insets: .init(top: 0, leading: 10, bottom: 0, trailing: 10))
                        context.control.configure(.fullScreen, insets: .init(top: 20, leading: 60, bottom: 34, trailing: 60))
                        
                        /// widgets for highest top location in halfscreen status
                        context.control.configure(.halfScreen(.top1)) {[
                            MinimizeWidget(),
                            SpacerWidget(),
                            SwitchWidget(),
                            AirplayWidget(),
                            SpacerWidget(50),
                            SettingsWidget(),
                        ]}
                        
                        /// widgets for lowest bottom location in halfscreen status
                        context.control.configure(.halfScreen(.bottom1)) {[
                            SeekBarWidget().padding(.horizontal, -20)
                        ]}
                        
                        /// widgets for medium bottom location in halfscreen status
                        context.control.configure(.halfScreen(.bottom2)) {[
                            TimelineWidget(),
                            SpacerWidget(),
                            WhateverWidget(),
                        ]}
                        
                        /// customize the center layout for halfscreen status (wider space than default)
                        context.control.configure(.halfScreen(.center)) { views in
                            HStack(spacing: 30) {
                                ForEach(views) { $0 }
                            }
                        }
                        
                        /// widgets for center location in halfscreen status
                        context.control.configure(.halfScreen(.center)) {[
                            StepBackWidget(),
                            PlaybackWidget(),
                            StepForwardWidget(),
                        ]}
                        
                        /// widgets for highest top location in fullscreen status
                        context.control.configure(.fullScreen(.top1)) {[
                            TitleWidget(),
                            SpacerWidget(),
                            ToggleWidget(),
                            AirplayWidget(),
                            ReviewWidget(),
                            SettingsWidget(),
                        ]}
                        
                        /// widgets for lowest bottom location in fullscreen status
                        context.control.configure(.fullScreen(.bottom1)) {[
                            ThumbUpWidget(),
                            ThumbDownWidget(),
                            MessageWidget(),
                            WatchLaterWidget(),
                            ShareWidget(),
                            MoreWidget(),
                            SpacerWidget(),
                            CameraWidget(),
                        ]}
                        
                        /// widgets for medium bottom location in fullscreen status
                        context.control.configure(.fullScreen(.bottom2)) {[
                            SeekBarWidget()
                        ]}
                        
                        /// widgets for highest bottom location in fullscreen status
                        context.control.configure(.fullScreen(.bottom3)) {[
                            TimelineWidget(),
                            SpacerWidget(),
                            FullscreenWidget(),
                        ]}
                        
                        /// customize the center layout for fullscreen status (wider space than default)
                        context.control.configure(.fullScreen(.center)) { views in
                            HStack(spacing: 30) {
                                ForEach(views) { $0 }
                            }
                        }
                        
                        /// widgets for center location in fullscreen status
                        context.control.configure(.fullScreen(.center)) {[
                            StepBackWidget(),
                            PlaybackWidget(),
                            StepForwardWidget(),
                        ]}
                        
                        /// the Control overlay presents when the VideoPlayerContainer display at the first time
                        /// users are only able to hide or show by tapping
                        /// we use default animation to animate the dismiss and present action
                        context.control.configure(displayStyle: .manual(firstAppear: true, animation: .default))
                        
                        /// play the demo video
                        let item = AVPlayerItem(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)
                        context.render.player.replaceCurrentItem(with: item)
                        context.render.player.play()
                    }
                
                /// fill up the remaining space for halfscreen
                if !orientation.isLandscape {
                    VideoDetail(width: proxy.size.width)
                }
            }
        }
        .ignoresSafeArea(edges: orientation.isLandscape ? .all : [])
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
