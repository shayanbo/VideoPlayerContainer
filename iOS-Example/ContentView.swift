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
                
                /// insets
                controlService.configure(.halfScreen, insets: .init(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                //MARK: Other
                
                // configure title
                context[TitleService.self].setTitle("WWDC Video")
                
                // load video item
                let item = AVPlayerItem(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)
                context[RenderService.self].player.replaceCurrentItem(with: item)
                context[RenderService.self].player.play()
                
                // configure toast view
                context[ToastService.self].configure { toast in
                    Button( toast as! String ) { }
                        .buttonStyle(.bordered)
                }
                
                // configure more widget
                context[MoreButtonService.self].bindClickHandler { [weak context] in
                    context?[ToastService.self].toast("Hahahahaha")
                }
                
                // configure control style
                context[ControlService.self].configure(displayStyle: .manual(firstAppear: true, animation: .default))
                
                context[FeatureService.self].configure(dismissOnClick: true)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

