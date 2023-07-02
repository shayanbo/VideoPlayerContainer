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
    
    @State var toggle = false
    
    var body: some View {
        
        PlayerWidget()
            .frame(height: 300)
            .bindContext(context)
            .ignoresSafeArea(edges: .all)
            .background(.black)
            .onAppear {
                
//                context[StatusService.self].toFullScreen()
                
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
                    IdentifableView(id: "a", content: {
                        Image(systemName: "chevron.down").frame(width: 25, height: 35).foregroundColor(.white)
                    }),
                    IdentifableView(id: "b", content: {
                        Spacer()
                    }),
                    IdentifableView(id: "c", content: {
                        Image(systemName: "switch.2").frame(width: 25, height: 35).foregroundColor(.white)
                    }),
                    IdentifableView(id: "d", content: {
                        Image(systemName: "airplayvideo").frame(width: 25, height: 35).foregroundColor(.white)
                    }),
                    IdentifableView(id: "e", content: {
                        Spacer().frame(width: 50)
                    }),
                    IdentifableView(id: "f", content: {
                        Image(systemName: "gearshape").frame(width: 25, height: 35).foregroundColor(.white)
                    }),
                ]}
                
                controlService.configure(.halfScreen(.bottom1)) {[
                    IdentifableView(id: "a", content: {
                        SeekBarWidget()
                            .padding(.horizontal, -20)
                    }),
                ]}
                
                controlService.configure(.halfScreen(.bottom2)) {[
                    IdentifableView(id: "a", content: { TimelineWidget() }),
                    IdentifableView(id: "b", content: { Spacer() }),
                    IdentifableView(id: "c", content: {
                        Image(systemName: "square.on.square").frame(width: 25, height: 25).foregroundColor(.white)
                    }),
                ]}
                
                controlService.configure(.halfScreen(.center)) { views in
                    HStack(spacing: 30) {
                        ForEach(views) { $0 }
                    }
                }
                
                controlService.configure(.halfScreen(.center)) {[
                    IdentifableView(id: "a", content: { StepBackWidget() }),
                    IdentifableView(id: "b", content: { PlaybackWidget() }),
                    IdentifableView(id: "c", content: { StepForwardWidget() }),
                ]}
                
                controlService.configure(.fullScreen(.top1)) {[
                    IdentifableView(id: "a", content: {
                        Text("Michael Jackson - Thriller (Official 4K Video)")
                            .lineLimit(1)
                            .foregroundColor(.white)
                    } ),
                    IdentifableView(id: "b", content: { Spacer() }),
                    IdentifableView(id: "c", content: {
                        Toggle("", isOn: $toggle).fixedSize().frame(width: 50)
                    }),
                    IdentifableView(id: "d", content: {
                        Image(systemName: "airplayvideo").frame(width: 25, height: 35).foregroundColor(.white)
                    }),
                    IdentifableView(id: "e", content: {
                        Image(systemName: "captions.bubble").frame(width: 25, height: 35).foregroundColor(.white)
                    }),
                    IdentifableView(id: "f", content: {
                        Image(systemName: "gearshape").frame(width: 25, height: 35).foregroundColor(.white)
                    }),
                ]}
                
                controlService.configure(.fullScreen(.bottom1)) {[
                    IdentifableView(id: "a", content: {
                        Image(systemName: "hand.thumbsup").frame(width: 25, height: 35).foregroundColor(.white)
                    }),
                    IdentifableView(id: "b", content: {
                        Image(systemName: "hand.thumbsdown").frame(width: 25, height: 35).foregroundColor(.white) }),
                    IdentifableView(id: "c", content: {
                        Image(systemName: "ellipsis.message")
                            .frame(width: 25, height: 35).foregroundColor(.white)
                            .allowsHitTesting(true)
                            .onTapGesture {
                                context[FeatureService.self].present(.right(.squeeze(0))) {
                                    AnyView(CommentWidget())
                                }
                            }
                    }),
                    IdentifableView(id: "d", content: {
                        Image(systemName: "plus.rectangle.on.rectangle").frame(width: 25, height: 35).foregroundColor(.white)
                    }),
                    IdentifableView(id: "e", content: {
                        Image(systemName: "arrowshape.turn.up.right").frame(width: 25, height: 35).foregroundColor(.white)
                    }),
                    IdentifableView(id: "f", content: {
                        Image(systemName: "ellipsis").frame(width: 25, height: 35).foregroundColor(.white)
                    }),
                    IdentifableView(id: "g", content: {
                        Spacer()
                    }),
                    IdentifableView(id: "h", content: {
                        Image(systemName: "video.badge.ellipsis").frame(width: 25, height: 35).foregroundColor(.white)
                    }),
                ]}
                
                controlService.configure(.fullScreen(.bottom2)) {[
                    IdentifableView(id: "a", content: { SeekBarWidget() })
                ]}
                
                controlService.configure(.fullScreen(.bottom3)) {[
                    IdentifableView(id: "a", content: { TimelineWidget() }),
                    IdentifableView(id: "b", content: { Spacer() }),
                    IdentifableView(id: "c", content: { Image(systemName: "arrow.down.right.and.arrow.up.left").foregroundColor(.white) }),
                ]}
                
                controlService.configure(.fullScreen(.center)) { views in
                    HStack(spacing: 30) {
                        ForEach(views) { $0 }
                    }
                }
                
                controlService.configure(.fullScreen(.center)) {[
                    IdentifableView(id: "a", content: { StepBackWidget() }),
                    IdentifableView(id: "b", content: { PlaybackWidget() }),
                    IdentifableView(id: "c", content: { StepForwardWidget() }),
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
