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
    
    @StateObject var context = Context()
    
    var body: some View {
        
        PlayerWidget(context)
            .background(.black)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: { _ in
                if UIDevice.current.orientation.isLandscape {
                    context[StatusService.self].toFullScreen()
                } else {
                    context[StatusService.self].toPortrait()
                }
            })
            .onAppear {
                
                context[StatusService.self].toPortrait()
                
                let controlService = context[ControlService.self]
                
                controlService.configure([.portrait(.top), .fullScreen(.top), .fullScreen(.bottom), .portrait(.bottom)], shadow: nil)
                controlService.configure(.portrait, insets: .init(top: 10, leading: 10, bottom: 10, trailing: 10))
                controlService.configure([.portrait(.top), .portrait(.bottom), .fullScreen(.top), .fullScreen(.bottom)], transition: .opacity)
                
                controlService.configure(.fullScreen, insets: .init(top: 20, leading: 0, bottom: 0, trailing: 0))
                
                controlService.configure([.portrait(.top1), .fullScreen(.top1)]) {[
                    CloseWidget(),
                    PiPWidget(),
                    Spacer(),
                    VolumeWidget(),
                ]}
                
                controlService.configure([.portrait(.bottom3), .fullScreen(.bottom3)]) {[
                    Spacer(),
                    AirplayWidget(),
                    MoreWidget(),
                ]}

                controlService.configure([.portrait(.bottom2), .fullScreen(.bottom2)]) {[
                    SeekBarWidget()
                ]}

                controlService.configure([.portrait(.bottom1), .fullScreen(.bottom1)]) {[
                    TimelineWidget(),
                    Spacer(),
                    DurationWidget(),
                ]}

                controlService.configure([.portrait(.center), .fullScreen(.center)]) {[
                    StepBackWidget(),
                    PlaybackButtonWidget(),
                    StepForwardWidget(),
                ]}

                controlService.configure([.portrait(.center), .fullScreen(.center)]) { views in
                    HStack(spacing: 60) {
                        ForEach(views) { $0 }
                    }
                }
                
                context[GestureService.self].configure(false)

                controlService.configure(displayStyle: .auto(firstAppear: true, animation: .default, duration: 5))

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
