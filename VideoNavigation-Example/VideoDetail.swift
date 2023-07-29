//
//  VideoDetail.swift
//  VideoNavigation-Example
//
//  Created by shayanbo on 2023/7/21.
//

import SwiftUI
import AVKit
import VideoPlayerContainer

struct VideoDetail: View {
    
    let video: Video
    
    let player: AVPlayer
    
    @StateObject private var context = Context()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        GeometryReader { proxy in
            VStack {
                PlayerWidget(context)
                    .background(.black)
                    .frame(height: proxy.size.width / video.aspectRatio)
                    .onAppear {
                        
                        let controlService = context[ControlService.self]
                        
                        controlService.configure(.halfScreen(.top), shadow: nil)
                        controlService.configure(.halfScreen(.bottom), shadow: nil)
                        controlService.configure(shadow: AnyView(
                            Rectangle().fill(.black.opacity(0.2)).allowsHitTesting(false)
                        ))
                        
                        controlService.configure(.halfScreen(.top), transition: .opacity)
                        controlService.configure(.halfScreen(.bottom), transition: .opacity)
                        
                        controlService.configure(.halfScreen, insets: .init(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                        controlService.configure(.halfScreen(.top1)) {[
                            BackWidget(),
                            Spacer(),
                            Image(systemName: "switch.2").frame(width: 25, height: 35).foregroundColor(.white),
                            Image(systemName: "airplayvideo").frame(width: 25, height: 35).foregroundColor(.white),
                            Spacer().frame(width: 50),
                            Image(systemName: "gearshape").frame(width: 25, height: 35).foregroundColor(.white),
                        ]}
                        
                        controlService.configure(.halfScreen(.bottom1)) {[
                            Rectangle().fill(.white).frame(height:5).cornerRadius(2).padding(.horizontal, -20)
                        ]}
                        
                        controlService.configure(.halfScreen(.bottom2)) {[
                            Text("00:00").foregroundColor(.white),
                            Spacer(),
                            Image(systemName: "square.on.square").frame(width: 25, height: 25).foregroundColor(.white),
                        ]}
                        
                        controlService.configure(.halfScreen(.center)) { views in
                            HStack(spacing: 30) {
                                ForEach(views) { $0 }
                            }
                        }
                        
                        controlService.configure(.halfScreen(.center)) {[
                            Image(systemName: "backward.end.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30),
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50),
                            Image(systemName: "forward.end.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30),
                        ]}
                        
                        controlService.configure(displayStyle: .manual(firstAppear: false, animation: .default))
                        
                        let renderService = context[RenderService.self]
                        renderService.attach(player: player)
                        
                        if player.currentItem == nil {
                            let item = AVPlayerItem(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)
                            player.replaceCurrentItem(with: item)
                            player.play()
                        } else if player.rate == 0 {
                            player.play()
                        }
                    }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}
