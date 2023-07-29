//
//  ContentView.swift
//  SystemVideoPlayer-Example
//
//  Created by shayanbo on 2023/7/18.
//

import SwiftUI
import VideoPlayerContainer
import AVKit

struct ContentView: View {
    
    /// create Context and let it have the same lifecycle with its enclosing underlying view
    @StateObject var context = Context()
    
    var body: some View {
        
        PlayerWidget(context)
            /// background modifier will cover the top safe area which make the VideoPlayerContainer looks better
            .background(.black)
            /// observe the device orientation and update status accordingly
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: { _ in
                if UIDevice.current.orientation.isLandscape {
                    /// update the status to Fullscreen, it will trigger the Control overlay UI updates. removing the portrait widgets and present fullscreen widgets
                    context[StatusService.self].toFullScreen()
                } else {
                    /// update the status to Portrait, it will trigger the Control overlay UI updates. removing the fullscreen widgets and present portrait widgets
                    context[StatusService.self].toPortrait()
                }
            })
            .onAppear {
                
                /// take Portrait as the initial status, so we can see the portrait-related widgets inside the Control overlay
                context[StatusService.self].toPortrait()
                
                /// hold the reference to the ControlService, we need to use it frequently below
                let controlService = context[ControlService.self]
                
                /// remove default shadow for Portrait's top & bottom and Fullscreen's top & bottom
                controlService.configure([.portrait(.top), .fullScreen(.top), .fullScreen(.bottom), .portrait(.bottom)], shadow: nil)
                
                /// setup insets for the whole Control overlay, since we would like to leave some space at the edges to make it looks better
                controlService.configure(.portrait, insets: .init(top: 10, leading: 10, bottom: 10, trailing: 10))
                controlService.configure(.fullScreen, insets: .init(top: 20, leading: 0, bottom: 0, trailing: 0))
                
                /// setup show/dismiss transition for Portrait's top & bottom and Fullscreen's top & bottom
                controlService.configure([.portrait(.top), .portrait(.bottom), .fullScreen(.top), .fullScreen(.bottom)], transition: .opacity)
                
                /// both portrait and fullscreen's top display same widgets: Close, PiP, and a Volume
                controlService.configure([.portrait(.top1), .fullScreen(.top1)]) {[
                    CloseWidget(),
                    PiPWidget(),
                    Spacer(),
                    VolumeWidget(),
                ]}
                
                /// both portrait and fullscreen's highest-bottom display the same widgets: Airplay, More
                controlService.configure([.portrait(.bottom3), .fullScreen(.bottom3)]) {[
                    Spacer(),
                    AirplayWidget(),
                    MoreWidget(),
                ]}

                /// both portrait and fullscreen's middle bottom display one widget: SeekBar
                controlService.configure([.portrait(.bottom2), .fullScreen(.bottom2)]) {[
                    SeekBarWidget()
                ]}

                /// both portrait and fullscreen's lowest bottom display the same widgets: ElapsedTime and Duration
                controlService.configure([.portrait(.bottom1), .fullScreen(.bottom1)]) {[
                    TimelineWidget(),
                    Spacer(),
                    DurationWidget(),
                ]}

                /// both portrait and fullscreen's center display the same widgets: StepBack, Playback, StepForward
                controlService.configure([.portrait(.center), .fullScreen(.center)]) {[
                    StepBackWidget(),
                    PlaybackButtonWidget(),
                    StepForwardWidget(),
                ]}

                /// customize the center layout for portrait and fullscreen. since the default center layout arrange subviews more closely
                controlService.configure([.portrait(.center), .fullScreen(.center)]) { views in
                    HStack(spacing: 60) {
                        ForEach(views) { $0 }
                    }
                    /// since the the bottom height is great than top height ( there's 3 layer widgets in the bottom), we need to lower the center layout to make it center in the whole VideoPlayerContainer
                    .offset(CGSize(width: 0, height: 23))
                }

                /// the Control overlay presents when the VideoPlayerContainer display at the first time
                /// users can click it to switch between hide and show
                /// it automatically dismiss in 5 seconds upon presenting
                controlService.configure(displayStyle: .auto(firstAppear: true, animation: .default, duration: 5))

                /// play the demo video
                let player = context[RenderService.self].player
                let item = AVPlayerItem(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)
                player.replaceCurrentItem(with: item)
                player.play()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
