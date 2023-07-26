//
//  ContentView.swift
//  Bilibili-Example
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
                PlayerWidget(context)
                    .frame(maxHeight: orientation.isLandscape ? .infinity : proxy.size.width * 0.5625)
                    /// background modifier will cover the top safe area which make the VideoPlayerContainer looks better
                    .background(.black)
                    /// observe the device orientation and update status accordingly
                    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: { _ in
                        self.orientation = UIDevice.current.orientation
                        
                        if UIDevice.current.orientation.isLandscape {
                            /// update the status to Fullscreen, it will trigger the Control overlay UI updates. removing the Halfscreen widgets and present fullscreen widgets
                            context[StatusService.self].toFullScreen()
                        } else {
                            /// update the status to Halfscreen, it will trigger the Control overlay UI updates. removing the fullscreen widgets and present portrait widgets
                            context[StatusService.self].toHalfScreen()
                        }
                    })
                    .onAppear {
                        
                        /// hold the reference to the ControlService, we need to use it frequently below
                        let controlService = context[ControlService.self]
                        
                        /// setup show/dismiss transition for halfscreen and fullscreen
                        controlService.configure([
                            .halfScreen(.bottom), .halfScreen(.top),
                            .fullScreen(.bottom), .fullScreen(.top),
                            .fullScreen(.left), .fullScreen(.right)
                        ], transition: .opacity)
                        
                        /// setup insets for the whole Control overlay, since we would like to leave some space at the edges to make it looks better
                        controlService.configure(.halfScreen, insets: .init(top: 10, leading: 5, bottom: 10, trailing: 5))
                        controlService.configure(.fullScreen, insets: .init(top: 0, leading: 60, bottom: 34, trailing: 60))
                        
                        /// widgets for highest-top location in halfscreen status
                        controlService.configure(.halfScreen(.top1)) {[
                            BackWidget(),
                            SpacerWidget(),
                            MusicWidget(),
                            AirplayWidget(),
                            MoreWidget(),
                        ]}
                        
                        /// widgets for lowest-bottom location in halfscreen status
                        controlService.configure(.halfScreen(.bottom1)) {[
                            PlaybackWidget(),
                            SeekBarWidget(),
                            TimelineWidget(),
                            FullscreenWidget(),
                        ]}
                        
                        /// widgets for highest-top location in fullscreen status
                        controlService.configure(.fullScreen(.top1)) {[
                            SpacerWidget(),
                            ClockWidget(),
                            SpacerWidget(),
                            NetworkWidget(),
                            BatteryWidget(),
                        ]}
                        
                        /// widgets for lowest-top location in fullscreen status
                        controlService.configure(.fullScreen(.top2)) {[
                            BackWidget(),
                            TitleWidget(),
                            SpacerWidget(),
                            ThumbUpWidget(),
                            ThumbDownWidget(),
                            CoinWidget(),
                            ChargeWidget(),
                            ShareWidget(),
                            MoreWidget(),
                        ]}
                        
                        /// widgets for lowest-bottom location in fullscreen status
                        controlService.configure(.fullScreen(.bottom1)) {[
                            PlaybackWidget(),
                            WhateverWidget1(),
                            WhateverWidget2(),
                            DanmakuWidget(),
                            CaptionWidget(),
                            SpeedWidget(),
                            QualityWidget(),
                        ]}
                        
                        /// widgets for medium-bottom location in fullscreen status
                        controlService.configure(.fullScreen(.bottom2)) {[
                            TimelineWidget(),
                            SeekBarWidget(),
                            DurationWidget(),
                        ]}
                        
                        /// widgets for right side in fullscreen status
                        controlService.configure(.fullScreen(.right)) {[
                            GiftWidget(),
                            SnapshotWidget(),
                        ]}
                        
                        /// widgets for left side in fullscreen status
                        controlService.configure(.fullScreen(.left)) {[
                            FollowWidget(),
                            SpacerWidget(),
                        ]}
                        
                        /// play the demo video
                        let item = AVPlayerItem(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)
                        context[RenderService.self].player.replaceCurrentItem(with: item)
                        context[RenderService.self].player.play()
                    }
                
                /// fill up the remaining space for portrait
                if !orientation.isLandscape {
                    Rectangle().fill(.white)
                }
            }
        }
        .ignoresSafeArea(edges: orientation.isLandscape ? .all : .bottom)
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
