//
//  ContentView.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/13.
//

import SwiftUI
import AVKit
import VideoPlayerContainer

let wwdcVideo = "https://devstreaming-cdn.apple.com/videos/wwdc/2023/10036/4/BB960BFD-F982-4800-8060-5674B049AC5A/cmaf/hvc/2160p_16800/hvc_2160p_16800.m3u8"

struct ContentView: View {
    
    @StateObject var context = Context()
    
    var body: some View {
        
        PlayerWidget()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .bindContext(context, launch: [
                LoadingService.self,
            ])
            .onAppear {
                
                let controlService = context[ControlService.self]
                
                /// halfScreen top
                controlService.configure(.halfScreen(.top)) {[
                    IdentifableView(id: "back") { BackButtonWidget() },
                    IdentifableView(id: "title") { TitleWidget() },
                    IdentifableView(id: "space") { Spacer() },
                    IdentifableView(id: "playback") {  Button("Hello World") {
                        context[FeatureService.self].present(.right(.squeeze(0))) {
                            Form {
                                Text("World")
                                Text("World")
                                Text("World")
                            }.frame(width: 100)
                        }
                    } },
                    IdentifableView(id: "more") {  MoreButtonWidget() }
                ]}
                
                /// halfScreen bottom
                controlService.configure(.halfScreen(.bottom)) {[
                    IdentifableView(id: "playback") {  PlaybackButtonWidget() },
                    IdentifableView(id: "progress") {  SeekBarWidget()   },
                    IdentifableView(id: "timeline") {  TimelineWidget()   }
                ]}
                
                /// halfScreen center
                controlService.configure(.halfScreen(.center)) {[
                    IdentifableView(id: "playback") {  Button("Hello World") {
                        context[FeatureService.self].present(.left(.cover)) {
                            Form {
                                Text("Hello")
                                Text("Hello")
                                Text("Hello")
                            }.frame(width: 100)
                        }
                    } },
                ]}
                
                // configure title
                context[TitleService.self].setTitle("WWDC Video")
                
                // load video item
                let item = AVPlayerItem(url: URL(string:wwdcVideo)!)
                context[RenderService.self].player.replaceCurrentItem(with: item)
                
                // configure toast view
                context[ToastService.self].configure { toast in
                    Text(toast.title)
                }
                
                // configure more widget
                context[MoreButtonService.self].bindClickHandler { [weak context] in
                    context?[ToastService.self].toast(ToastService.Toast(title: "Hahahahaha"))
                }
                
                // configure control style
//                context[ControlService.self].configure(controlStyle: .manual(firstAppear: true))
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

