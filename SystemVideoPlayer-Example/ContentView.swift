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
    
    @State var orientation = UIDevice.current.orientation
    
    var body: some View {
        
        PlayerWidget(context)
            .frame(maxWidth: orientation.isLandscape ? .infinity : .infinity)
            .background(.black)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: { _ in
                self.orientation = UIDevice.current.orientation
                
                if UIDevice.current.orientation.isLandscape {
                    context[StatusService.self].toFullScreen()
                } else {
                    context[StatusService.self].toPortrait()
                }
            })
            .onAppear {
                
                context[StatusService.self].toFullScreen()
                
                let controlService = context[ControlService.self]
                
                controlService.configure([.portrait(.top), .portrait(.bottom)], shadow: nil)
                controlService.configure(.portrait, insets: .init(top: 10, leading: 10, bottom: 10, trailing: 10))
                controlService.configure([.portrait(.top), .portrait(.bottom)], transition: .opacity)
                
                controlService.configure([.portrait(.top1), .fullScreen(.top1)]) {[
                    Image(systemName: "xmark").foregroundColor(.white),
                    Image(systemName: "pip.enter").foregroundColor(.white),
                    Spacer(),
                    VolumeWidget(),
                ]}
                
                controlService.configure([.portrait(.bottom3), .fullScreen(.bottom3)]) {[
                    Spacer(),
                    Image(systemName: "airplayvideo").foregroundColor(.white),
                    Image(systemName: "ellipsis.circle").foregroundColor(.white),
                ]}
                
                controlService.configure([.portrait(.bottom2), .fullScreen(.bottom2)]) {[
                    Rectangle().fill(.white).frame(height:5).cornerRadius(2)
                ]}
                
                controlService.configure([.portrait(.bottom1), .fullScreen(.bottom1)]) {[
                    Text("00:00").font(.system(size: 12)).foregroundColor(.white).opacity(0.7),
                    Spacer(),
                    Text("00:00").font(.system(size: 12)).foregroundColor(.white).opacity(0.7),
                ]}
                
                controlService.configure([.portrait(.center), .fullScreen(.bottom1)]) {[
                    Image(systemName: "gobackward.10").resizable().scaledToFit().frame(width: 30, height: 30).foregroundColor(.white),
                    Image(systemName: "play.fill").resizable().scaledToFit().frame(width: 30, height: 30).foregroundColor(.white),
                    Image(systemName: "goforward.10").resizable().scaledToFit().frame(width: 30, height: 30).foregroundColor(.white),
                ]}
                
                controlService.configure([.portrait(.center), .fullScreen(.center)]) { views in
                    HStack(spacing: 60) {
                        ForEach(views) { $0 }
                    }
                }
                
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
