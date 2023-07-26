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
                            context[StatusService.self].toFullScreen()
                        } else {
                            /// update the status to Portrait, it will trigger the Control overlay UI updates. removing the fullscreen widgets and present portrait widgets
                            context[StatusService.self].toHalfScreen()
                        }
                    })
                    .onAppear {
                        
                        /// hold the reference to the ControlService, we need to use it frequently below
                        let controlService = context[ControlService.self]
                        
                        /// remove default shadow for Portrait's top & bottom and Fullscreen's top & bottom
                        controlService.configure([
                            .halfScreen(.top), .halfScreen(.bottom),
                            .fullScreen(.top), .fullScreen(.bottom),
                        ], shadow: nil)
                        
                        /// add a shadow covering the whole Control overlay
                        controlService.configure(shadow: AnyView(
                            Rectangle().fill(.black.opacity(0.2)).allowsHitTesting(false)
                        ))
                        
                        /// setup show/dismiss transition for Fullscreen's top & bottom and Halfscreen's top & bottom
                        controlService.configure([
                            .halfScreen(.top), .halfScreen(.bottom),
                            .fullScreen(.top), .fullScreen(.bottom),
                        ], transition: .opacity)
                        
                        /// setup insets for the whole Control overlay, since we would like to leave some space at the edges to make it looks better
                        controlService.configure(.halfScreen, insets: .init(top: 0, leading: 10, bottom: 0, trailing: 10))
                        controlService.configure(.fullScreen, insets: .init(top: 20, leading: 60, bottom: 34, trailing: 60))
                        
                        /// widgets for highest top location in halfscreen status
                        controlService.configure(.halfScreen(.top1)) {[
                            MinimizeWidget(),
                            SpacerWidget(),
                            SwitchWidget(),
                            AirplayWidget(),
                            SpacerWidget(50),
                            SettingsWidget(),
                        ]}
                        
                        /// widgets for lowest bottom location in halfscreen status
                        controlService.configure(.halfScreen(.bottom1)) {[
                            SeekBarWidget().padding(.horizontal, -20)
                        ]}
                        
                        /// widgets for medium bottom location in halfscreen status
                        controlService.configure(.halfScreen(.bottom2)) {[
                            TimelineWidget(),
                            SpacerWidget(),
                            WhateverWidget(),
                        ]}
                        
                        /// customize the center layout for halfscreen status (wider space than default)
                        controlService.configure(.halfScreen(.center)) { views in
                            HStack(spacing: 30) {
                                ForEach(views) { $0 }
                            }
                        }
                        
                        /// widgets for center location in halfscreen status
                        controlService.configure(.halfScreen(.center)) {[
                            StepBackWidget(),
                            PlaybackWidget(),
                            StepForwardWidget(),
                        ]}
                        
                        /// widgets for highest top location in fullscreen status
                        controlService.configure(.fullScreen(.top1)) {[
                            TitleWidget(),
                            SpacerWidget(),
                            ToggleWidget(),
                            AirplayWidget(),
                            ReviewWidget(),
                            SettingsWidget(),
                        ]}
                        
                        /// widgets for lowest bottom location in fullscreen status
                        controlService.configure(.fullScreen(.bottom1)) {[
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
                        controlService.configure(.fullScreen(.bottom2)) {[
                            SeekBarWidget()
                        ]}
                        
                        /// widgets for highest bottom location in fullscreen status
                        controlService.configure(.fullScreen(.bottom3)) {[
                            TimelineWidget(),
                            SpacerWidget(),
                            FullscreenWidget(),
                        ]}
                        
                        /// customize the center layout for fullscreen status (wider space than default)
                        controlService.configure(.fullScreen(.center)) { views in
                            HStack(spacing: 30) {
                                ForEach(views) { $0 }
                            }
                        }
                        
                        /// widgets for center location in fullscreen status
                        controlService.configure(.fullScreen(.center)) {[
                            StepBackWidget(),
                            PlaybackWidget(),
                            StepForwardWidget(),
                        ]}
                        
                        /// the Control overlay presents when the VideoPlayerContainer display at the first time
                        /// users are only able to hide or show by tapping
                        /// we use default animation to animate the dismiss and present action
                        controlService.configure(displayStyle: .manual(firstAppear: true, animation: .default))
                        
                        /// play the demo video
                        let player = context[RenderService.self].player
                        let item = AVPlayerItem(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)
                        player.replaceCurrentItem(with: item)
                        player.play()
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
