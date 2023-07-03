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
    
    @StateObject var context = Context()
    
    @State var orientation = UIDevice.current.orientation
    
    @State var toggle = false
    
    var body: some View {
        
        PlayerWidget()
            .frame(maxHeight: orientation.isLandscape ? .infinity : 300)
            .bindContext(context)
            .ignoresSafeArea(edges: .all)
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
                
                controlService.configure(.halfScreen(.top), shadow: nil)
                controlService.configure(.halfScreen(.bottom), shadow: nil)
                controlService.configure(.fullScreen(.top), shadow: nil)
                controlService.configure(.fullScreen(.bottom), shadow: nil)
                controlService.configure(shadow: AnyView(
                    Rectangle().fill(.black.opacity(0.2)).allowsHitTesting(false)
                ))
                
                controlService.configure(.halfScreen(.top), transition: .opacity)
                controlService.configure(.halfScreen(.bottom), transition: .opacity)
                
                controlService.configure(.halfScreen, insets: .init(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                controlService.configure(.halfScreen(.top1)) {[
                    Image(systemName: "chevron.down").frame(width: 25, height: 35).foregroundColor(.white),
                    Spacer(),
                    Image(systemName: "switch.2").frame(width: 25, height: 35).foregroundColor(.white),
                    Image(systemName: "airplayvideo").frame(width: 25, height: 35).foregroundColor(.white),
                    Spacer().frame(width: 50),
                    Image(systemName: "gearshape").frame(width: 25, height: 35).foregroundColor(.white),
                ]}
                
                controlService.configure(.halfScreen(.bottom1)) {[
                    SeekBarWidget().padding(.horizontal, -20)
                ]}
                
                controlService.configure(.halfScreen(.bottom2)) {[
                    TimelineWidget(),
                    Spacer(),
                    Image(systemName: "square.on.square").frame(width: 25, height: 25).foregroundColor(.white),
                ]}
                
                controlService.configure(.halfScreen(.center)) { views in
                    HStack(spacing: 30) {
                        ForEach(views) { $0 }
                    }
                }
                
                controlService.configure(.halfScreen(.center)) {[
                    StepBackWidget(),
                    PlaybackWidget(),
                    StepForwardWidget(),
                ]}
                
                controlService.configure(.fullScreen(.top1)) {[
                    Text("Michael Jackson - Thriller (Official 4K Video)").lineLimit(1).foregroundColor(.white),
                    Spacer(),
                    Toggle("", isOn: $toggle).fixedSize().frame(width: 50),
                    Image(systemName: "airplayvideo").frame(width: 25, height: 35).foregroundColor(.white),
                    Image(systemName: "captions.bubble").frame(width: 25, height: 35).foregroundColor(.white),
                    Image(systemName: "gearshape").frame(width: 25, height: 35).foregroundColor(.white),
                ]}
                
                controlService.configure(.fullScreen(.bottom1)) {[
                    Image(systemName: "hand.thumbsup").frame(width: 25, height: 35).foregroundColor(.white),
                    Image(systemName: "hand.thumbsdown").frame(width: 25, height: 35).foregroundColor(.white),
                    Image(systemName: "ellipsis.message")
                        .frame(width: 25, height: 35).foregroundColor(.white)
                        .allowsHitTesting(true)
                        .onTapGesture {
                            context[FeatureService.self].present(.right(.squeeze(0))) {
                                AnyView(CommentWidget())
                            }
                        },
                    Image(systemName: "plus.rectangle.on.rectangle").frame(width: 25, height: 35).foregroundColor(.white),
                    Image(systemName: "arrowshape.turn.up.right").frame(width: 25, height: 35).foregroundColor(.white),
                    Image(systemName: "ellipsis").frame(width: 25, height: 35).foregroundColor(.white),
                    Spacer(),
                    Image(systemName: "video.badge.ellipsis").frame(width: 25, height: 35).foregroundColor(.white),
                ]}
                
                controlService.configure(.fullScreen(.bottom2)) {[
                    SeekBarWidget()
                ]}
                
                controlService.configure(.fullScreen(.bottom3)) {[
                    TimelineWidget(),
                    Spacer(),
                    Image(systemName: "arrow.down.right.and.arrow.up.left").foregroundColor(.white),
                ]}
                
                controlService.configure(.fullScreen(.center)) { views in
                    HStack(spacing: 30) {
                        ForEach(views) { $0 }
                    }
                }
                
                controlService.configure(.fullScreen(.center)) {[
                    StepBackWidget(),
                    PlaybackWidget(),
                    StepForwardWidget(),
                ]}
                
                controlService.configure(.fullScreen(.top), transition: .opacity)
                controlService.configure(.fullScreen(.bottom), transition: .opacity)
                
                controlService.configure(displayStyle: .manual(firstAppear: true, animation: .default))
                
                controlService.configure(.fullScreen, insets: .init(top: 20, leading: 60, bottom: 34, trailing: 60))
                
                let player = context[RenderService.self].player
                player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2023/10036/4/BB960BFD-F982-4800-8060-5674B049AC5A/cmaf/hvc/2160p_16800/hvc_2160p_16800.m3u8")!))
                player.play()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
