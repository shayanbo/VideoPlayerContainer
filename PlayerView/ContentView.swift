//
//  ContentView.swift
//  PlayerView
//
//  Created by shayanbo on 2023/6/13.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @StateObject var context = Context()
    
    var body: some View {
        
        PlayerWidget()
            .ignoresSafeArea(edges: .vertical)
            .frame(maxWidth: .infinity, maxHeight: 300)
            .bindContext(context, launch: [
                LoadingService.self,
            ])
            .onAppear {
                
                let controlService = context[ControlService.self]
                
                controlService.configure(.halfScreen(.top)) {[
                    IdentifableView(id: "back") { BackButtonWidget() },
                    IdentifableView(id: "title") { TitleWidget() },
                    IdentifableView(id: "space") { Spacer() },
                    IdentifableView(id: "playback") {  Button("Hello World") {
                        context[FeatureService.self].present(.right(.squeeze)) {AnyView(
                            Form {
                                Text("World")
                                Text("World")
                                Text("World")
                            }.frame(width: 100)
                        )}
                    } },
                    IdentifableView(id: "d") {  MoreButtonWidget() }
                ]}
                
                controlService.configure(.halfScreen(.bottom)) {[
                    IdentifableView(id: "playback") {  PlaybackButtonWidget() },
                    IdentifableView(id: "progress") {  ProgressWidget()   },
                    IdentifableView(id: "timeline") {  TimelineWidget()   }
                ]}
                
                controlService.configure(.halfScreen(.center)) {[
                    IdentifableView(id: "playback") {  Button("Hello World") {
                        context[FeatureService.self].present(.left(.cover)) {AnyView(
                            Form {
                                Text("Hello")
                                Text("Hello")
                                Text("Hello")
                            }.frame(width: 100)
                        )}
                    } },
                ]}
                
                context[TitleService.self].setTitle("WWDC Video")
                
                let item = AVPlayerItem(url: URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2023/10036/4/BB960BFD-F982-4800-8060-5674B049AC5A/cmaf/hvc/2160p_16800/hvc_2160p_16800.m3u8")!)
                context[RenderService.self].player.replaceCurrentItem(with: item)
                
                context[ToastService.self].configure { toast in
                    Text(toast.title)
                }
                
                context[MoreButtonService.self].bindClickHandler { [weak context] in
                    context?[ToastService.self].toast(ToastService.Toast(title: "哈哈哈"))
                }
                
                context[ControlService.self].configure(controlStyle: .manual)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

