//
//  ContentView.swift
//  TikTok-Example
//
//  Created by shayanbo on 2023/6/29.
//

import SwiftUI
import VideoPlayerContainer
import AVKit

struct ContentView: View {
    
    @StateObject var context = Context()
    
    var body: some View {
        
        TabView {
            
            PlayerWidget(context, launch: [PlaybackService.self])
                .onDisappear {
                    let player = context[RenderService.self].player
                    player.pause()
                }
                .onAppear {
                    context[StatusService.self].toPortrait()
                    
                    let controlService = context[ControlService.self]
                    
                    controlService.configure(displayStyle: .always)
                    
                    controlService.configure(.portrait(.top), shadow: nil)
                    controlService.configure(.portrait(.bottom), shadow: nil)
                    
                    controlService.configure(.portrait(.bottom1)) {[
                        SeekBarWidget()
                    ]}
                    
                    controlService.configure(.portrait(.right)) { views in
                        VStack(spacing: 20) {
                            ForEach(views) { $0 }
                        }
                    }
                    
                    controlService.configure(.portrait(.center)) {[
                        Spacer().frame(width: 50)
                    ]}
                    
                    controlService.configure(.portrait(.right)) {[
                        Spacer(),
                        
                        Image(systemName: "person.fill.badge.plus").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30),
                        
                        Image(systemName: "heart.fill").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30),
                        
                        Image(systemName: "ellipsis.message.fill")
                            .resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30)
                            .allowsHitTesting(true)
                            .onTapGesture {
                                
                                context[FeatureService.self].present(.bottom(.squeeze(0))) { [weak context] in
                                    context?[ControlService.self].dismiss()
                                } beforeDismiss: { [weak context] in
                                    context?[ControlService.self].present()
                                } content: {
                                    AnyView(
                                        Form {
                                            Text("hello")
                                            Text("hello")
                                            Text("hello")
                                        }.frame(height: 400)
                                    )
                                }
                            },
                        
                        Image(systemName: "star.fill").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30),
                        
                        Image(systemName: "arrowshape.turn.up.right.fill").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30),
                        
                        Image(systemName: "circle.fill").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30),
                        
                        Spacer().frame(height: 0),
                    ]}
                    
                    controlService.configure(.portrait(.left)) { views in
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(views) { $0 }
                        }
                    }
                    
                    controlService.configure(.portrait(.left)) {[
                        
                        Spacer(),
                        Text("@Street Fighter").fontWeight(.medium).foregroundColor(.white),
                        
                        Text("HahahahahhahahahhahahahhahahahhahahahhahahahhahahahHahahahahhahahahhahahahhahahahhahahahhahahahhahahah")
                            .fontWeight(.regular)
                            .foregroundColor(.white),
                        
                        Spacer().frame(height: 0),
                    ]}
                    
                    context[FeatureService.self].configure(dismissOnClick: true)
                    
                    controlService.configure(.portrait(.left), transition: .opacity)
                    controlService.configure(.portrait(.right), transition: .opacity)
                    
                    controlService.configure(displayStyle: .custom(animation: .default))
                    controlService.present()
                    
                    context[RenderService.self].fit()
                    
                    let player = context[RenderService.self].player
                    if player.currentItem == nil {
                        let item = AVPlayerItem(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)
                        player.replaceCurrentItem(with: item)
                    }
                    player.play()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .tabItem {
                    Label("Home", systemImage: "house.circle.fill")
                }
            
            Text("Second Page")
                .tabItem {
                    Label("Friends", systemImage: "link.circle.fill")
                }
            
            Text("Third Page")
                .tabItem {
                    Label("Message", systemImage: "message.circle.fill")
                }
            
            Text("Forth Page")
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
