//
//  ContentView.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/13.
//

import SwiftUI
import AVKit
import VideoPlayerContainer
import UIKit

let wwdcVideo = "https://devstreaming-cdn.apple.com/videos/wwdc/2023/10036/4/BB960BFD-F982-4800-8060-5674B049AC5A/cmaf/hvc/2160p_16800/hvc_2160p_16800.m3u8"

struct ContentView: View {
    
    @StateObject var context = Context()
    
    @State var orientation = UIDevice.current.orientation
    
    var body: some View {
        
        PlayerWidget()
            .ignoresSafeArea(edges: .vertical)
            .frame(maxHeight: orientation.isLandscape ? .infinity : 300)
            .bindContext(context, launch: [
                LoadingService.self,
            ])
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
                
                //MARK: HalfScreen Configuration
                
                /// halfScreen top
                controlService.configure(.halfScreen(.top1)) {[
                    BackButtonWidget(),
                    TitleWidget(),
                    Spacer(),
                    Button("Hello World") {
                        context[FeatureService.self].present(.right(.squeeze(0))) {
                            AnyView(
                                Form {
                                    Text("World")
                                    Text("World")
                                    Text("World")
                                }.frame(width: 100)
                            )
                        }
                    },
                    MoreButtonWidget()
                ]}
                
                controlService.configure(.halfScreen(.bottom2)) {[
                    Image(systemName: "scribble"),
                    Image(systemName: "eraser"),
                    Image(systemName: "paperplane"),
                    Image(systemName: "bookmark"),
                    Image(systemName: "arrowshape.turn.up.right"),
                ]}
                
                /// halfScreen bottom
                controlService.configure(.halfScreen(.bottom1)) {[
                    PlaybackButtonWidget(),
                    SeekBarWidget(),
                    TimelineWidget()
                ]}
                
                /// halfScreen center
                controlService.configure(.halfScreen(.center)) {[
                    Button("Hello World") {
                        context[FeatureService.self].present(.top(.cover)) {
                            AnyView(
                                Form {
                                    Text("Hello")
                                    Text("Hello")
                                    Text("Hello")
                                }.frame(height: 100)
                            )
                        }
                    },
                ]}
                
                //MARK: FullScreen Configuration
                
                /// fullScreen top
                controlService.configure(.fullScreen(.top1)) {[
                    BackButtonWidget(),
                    TitleWidget(),
                    Spacer(),
                    Image(systemName: "scribble"),
                    Image(systemName: "eraser"),
                    Image(systemName: "paperplane"),
                    Image(systemName: "bookmark"),
                    Image(systemName: "arrowshape.turn.up.right"),
                    MoreButtonWidget()
                ]}
                
                /// fullScreen bottom
                controlService.configure(.fullScreen(.bottom1)) {[
                    PlaybackButtonWidget(),
                    SeekBarWidget(),
                    TimelineWidget()
                ]}
                
                /// fullScreen center
                controlService.configure(.fullScreen(.left)) {[
                    Image(systemName: "lock.open"),
                ]}
                
                //MARK: Other
                
                // configure title
                context[TitleService.self].setTitle("WWDC Video")
                
                // load video item
                let item = AVPlayerItem(url: URL(string:wwdcVideo)!)
                context[RenderService.self].player.replaceCurrentItem(with: item)
                
                // configure toast view
                context[ToastService.self].configure { toast in
                    Text( toast as! String )
                }
                
                // configure more widget
                context[MoreButtonService.self].bindClickHandler { [weak context] in
                    context?[ToastService.self].toast("Hahahahaha")
                }
                
                // configure control style
                context[ControlService.self].configure(displayStyle: .always)
                
                context[FeatureService.self].configure(dismissOnClick: true)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

