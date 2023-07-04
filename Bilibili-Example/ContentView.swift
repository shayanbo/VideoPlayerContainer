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
    
    @StateObject var context = Context()
    
    @State var orientation = UIDevice.current.orientation
    
    var body: some View {
        
        VStack {
            GeometryReader { proxy in
                PlayerWidget()
                    .frame(maxHeight: orientation.isLandscape ? .infinity : proxy.size.width * 0.5625)
                    .bindContext(context)
                    .background(.black)
                    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: { _ in
                        self.orientation = UIDevice.current.orientation
                        
                        if UIDevice.current.orientation.isLandscape {
                            context[StatusService.self].toFullScreen()
                        } else {
                            context[StatusService.self].toHalfScreen()
                        }
                    })
                    .onAppear {
                        
                        let controlService = context[ControlService.self]
                        
                        controlService.configure(.halfScreen(.bottom), transition: .opacity)
                        controlService.configure(.halfScreen(.top), transition: .opacity)
                        
                        controlService.configure(.halfScreen, insets: .init(top: 10, leading: 5, bottom: 10, trailing: 5))
                        
                        controlService.configure(.halfScreen(.top1)) {[
                            Image(systemName: "chevron.left").foregroundColor(.white).frame(width: 30, height: 30),
                            Spacer(),
                            Image(systemName: "music.quarternote.3").foregroundColor(.white).frame(width: 30, height: 30),
                            Image(systemName: "airplayvideo").foregroundColor(.white).frame(width: 30, height: 30),
                            Image(systemName: "ellipsis").foregroundColor(.white).frame(width: 30, height: 30).rotationEffect(.degrees(90)),
                        ]}
                        
                        controlService.configure(.halfScreen(.bottom1)) {[
                            PlaybackWidget(),
                            SeekBarWidget(),
                            TimelineWidget(),
                            Image(systemName: "arrow.up.left.and.arrow.down.right").frame(width: 30, height: 30).foregroundColor(.white),
                        ]}
                        
                        controlService.configure(.fullScreen, insets: .init(top: 0, leading: 60, bottom: 34, trailing: 60))
                        
                        controlService.configure(.fullScreen(.bottom), transition: .opacity)
                        controlService.configure(.fullScreen(.top), transition: .opacity)
                        controlService.configure(.fullScreen(.left), transition: .opacity)
                        controlService.configure(.fullScreen(.right), transition: .opacity)
                        
                        controlService.configure(.fullScreen(.top1)) {[
                            Spacer(),
                            Text("12:12").foregroundColor(.white),
                            Spacer(),
                            Image(systemName: "wifi").foregroundColor(.white),
                            Image(systemName: "battery.75").foregroundColor(.white),
                        ]}
                        
                        controlService.configure(.fullScreen(.top2)) {[
                            Image(systemName: "chevron.left").foregroundColor(.white).frame(width: 30, height: 30),
                            Text("Michael Jackson - Thriller (Official 4K Video)").foregroundColor(.white),
                            Spacer(),
                            Image(systemName: "hand.thumbsup").foregroundColor(.white).frame(width: 30, height: 30),
                            Image(systemName: "hand.thumbsdown").foregroundColor(.white).frame(width: 30, height: 30),
                            Image(systemName: "bitcoinsign.circle").foregroundColor(.white).frame(width: 30, height: 30),
                            Image(systemName: "battery.100.bolt").foregroundColor(.white).frame(width: 30, height: 30).rotationEffect(.degrees(90)),
                            Image(systemName: "arrowshape.turn.up.right").foregroundColor(.white).frame(width: 30, height: 30),Image(systemName: "ellipsis").foregroundColor(.white).frame(width: 30, height: 30).rotationEffect(.degrees(90)),
                        ]}
                        
                        controlService.configure(.fullScreen(.bottom1)) {[
                            PlaybackWidget(),
                            Image(systemName: "heart.text.square.fill").foregroundColor(.white).frame(width: 30, height: 30),
                            Image(systemName: "square.text.square.fill").foregroundColor(.white).frame(width: 30, height: 30),
                            DanmakuWidget(),
                            Text("字幕").font(.subheadline).foregroundColor(.white),
                            Text("倍速").font(.subheadline).foregroundColor(.white),
                            Text("自动").font(.subheadline).foregroundColor(.white),
                        ]}
                        
                        controlService.configure(.fullScreen(.bottom2)) {[
                            TimelineWidget(),
                            SeekBarWidget(),
                            DurationWidget(),
                        ]}
                        
                        controlService.configure(.fullScreen(.right)) {[
                            Image(systemName: "gift.fill").foregroundColor(.white).frame(width: 30, height: 30),
                            Image(systemName: "camera.fill").foregroundColor(.white).frame(width: 30, height: 30),
                        ]}
                        
                        controlService.configure(.fullScreen(.left)) {[
                            Spacer().frame(height: 10),
                            Button("+关注") {}
                                .foregroundColor(.white)
                                .cornerRadius(3)
                                .buttonStyle(.borderedProminent),
                            Spacer(),
                        ]}
                        
                        let item = AVPlayerItem(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)
                        context[RenderService.self].player.replaceCurrentItem(with: item)
                        context[RenderService.self].player.play()
                    }
            }
            Spacer()
        }
        .ignoresSafeArea(edges: orientation.isLandscape ? .all : [])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
