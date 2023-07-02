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
    
    var body: some View {
        
        PlayerWidget()
            .frame(height: 300)
            .bindContext(context)
            .ignoresSafeArea(.all)
            .background(.black)
            .onAppear {
                
                let controlService = context[ControlService.self]
                
//                context[StatusService.self].toFullScreen()
                
                controlService.configure(.halfScreen(.bottom), transition: .opacity)
                controlService.configure(.halfScreen(.top), transition: .opacity)
                
                controlService.configure(.halfScreen, insets: .init(top: 10, leading: 5, bottom: 10, trailing: 5))
                
                controlService.configure(.halfScreen(.top1)) {[
                    IdentifableView(id: "a", content: { Image(systemName: "chevron.left").foregroundColor(.white).frame(width: 30, height: 30) }),
                    IdentifableView(id: "b", content: { Spacer() }),
                    IdentifableView(id: "c", content: { Image(systemName: "music.quarternote.3").foregroundColor(.white).frame(width: 30, height: 30) }),
                    IdentifableView(id: "d", content: { Image(systemName: "airplayvideo").foregroundColor(.white).frame(width: 30, height: 30) }),
                    IdentifableView(id: "e", content: { Image(systemName: "ellipsis").foregroundColor(.white).frame(width: 30, height: 30).rotationEffect(.degrees(90)) }),
                ]}
                
                controlService.configure(.halfScreen(.bottom1)) {[
                    IdentifableView(id: "a", content: { PlaybackWidget() }),
                    IdentifableView(id: "b", content: { SeekBarWidget() }),
                    IdentifableView(id: "c", content: { TimelineWidget() }),
                    IdentifableView(id: "d", content: { Image(systemName: "arrow.up.left.and.arrow.down.right").frame(width: 30, height: 30).foregroundColor(.white) }),
                ]}
                
                controlService.configure(.fullScreen, insets: .init(top: 0, leading: 60, bottom: 34, trailing: 60))
                
                controlService.configure(.fullScreen(.bottom), transition: .opacity)
                controlService.configure(.fullScreen(.top), transition: .opacity)
                controlService.configure(.fullScreen(.left), transition: .opacity)
                controlService.configure(.fullScreen(.right), transition: .opacity)
                
                controlService.configure(.fullScreen(.top1)) {[
                    IdentifableView(id: "a", content: { Spacer() }),
                    IdentifableView(id: "b", content: { Text("12:12").foregroundColor(.white) }),
                    IdentifableView(id: "c", content: { Spacer() }),
                    IdentifableView(id: "d", content: { Image(systemName: "wifi").foregroundColor(.white) }),
                    IdentifableView(id: "e", content: { Image(systemName: "battery.75").foregroundColor(.white) }),
                ]}
                
                controlService.configure(.fullScreen(.top2)) {[
                    IdentifableView(id: "a", content: { Image(systemName: "chevron.left").foregroundColor(.white).frame(width: 30, height: 30) }),
                    IdentifableView(id: "b", content: { Text("Michael Jackson - Thriller (Official 4K Video)").foregroundColor(.white) }),
                    IdentifableView(id: "c", content: { Spacer() }),
                    IdentifableView(id: "c", content: { Image(systemName: "hand.thumbsup").foregroundColor(.white).frame(width: 30, height: 30) }),
                    IdentifableView(id: "d", content: { Image(systemName: "hand.thumbsdown").foregroundColor(.white).frame(width: 30, height: 30) }),
                    IdentifableView(id: "e", content: { Image(systemName: "bitcoinsign.circle").foregroundColor(.white).frame(width: 30, height: 30) }),
                    IdentifableView(id: "f", content: { Image(systemName: "battery.100.bolt").foregroundColor(.white).frame(width: 30, height: 30).rotationEffect(.degrees(90)) }),
                    IdentifableView(id: "g", content: { Image(systemName: "arrowshape.turn.up.right").foregroundColor(.white).frame(width: 30, height: 30) }),
                    IdentifableView(id: "h", content: { Image(systemName: "ellipsis").foregroundColor(.white).frame(width: 30, height: 30).rotationEffect(.degrees(90)) }),
                ]}
                
                controlService.configure(.fullScreen(.bottom1)) {[
                    IdentifableView(id: "a", content: { PlaybackWidget() }),
                    IdentifableView(id: "b", content: { Image(systemName: "heart.text.square.fill").foregroundColor(.white).frame(width: 30, height: 30) }),
                    IdentifableView(id: "c", content: { Image(systemName: "square.text.square.fill").foregroundColor(.white).frame(width: 30, height: 30) }),
                    IdentifableView(id: "d", content: { DanmakuWidget() }),
                    IdentifableView(id: "e", content: { Text("字幕").font(.subheadline).foregroundColor(.white) }),
                    IdentifableView(id: "f", content: { Text("倍速").font(.subheadline).foregroundColor(.white) }),
                    IdentifableView(id: "g", content: { Text("自动").font(.subheadline).foregroundColor(.white) }),
                ]}
                
                controlService.configure(.fullScreen(.bottom2)) {[
                    IdentifableView(id: "a", content: { TimelineWidget() }),
                    IdentifableView(id: "b", content: { SeekBarWidget() }),
                    IdentifableView(id: "c", content: { DurationWidget() }),
                ]}
                
                controlService.configure(.fullScreen(.right)) {[
                    IdentifableView(id: "b", content: { Image(systemName: "gift.fill").foregroundColor(.white).frame(width: 30, height: 30) }),
                    IdentifableView(id: "c", content: { Image(systemName: "camera.fill").foregroundColor(.white).frame(width: 30, height: 30) }),
                ]}
                
                controlService.configure(.fullScreen(.left)) {[
                    IdentifableView(id: "a", content: { Spacer().frame(height: 10) }),
                    IdentifableView(id: "b", content: {
                        Button("+关注") {}
                            .foregroundColor(.white)
                            .cornerRadius(3)
                            .buttonStyle(.borderedProminent)
                    }),
                    IdentifableView(id: "c", content: { Spacer() }),
                ]}
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
