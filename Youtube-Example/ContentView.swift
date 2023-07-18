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
        
        GeometryReader { proxy in
            VStack {
                PlayerWidget(context, launch: [StepService.self])
                    .frame(maxHeight: orientation.isLandscape ? .infinity : proxy.size.width * 0.5625)
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
                        let item = AVPlayerItem(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)
                        player.replaceCurrentItem(with: item)
                        player.play()
                    }
                
                if !orientation.isLandscape {
                    
                    List {
                        Group {
                            Text("Official Evo Moment #37, Daigo vs Justin Evo 2004 in HD")
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .padding(.all, 10)
                            Text("6.59M Views 7 years ago ...Unfold")
                                .fontWeight(.regular)
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                            HStack {
                                Image("demo")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(15)
                                Text("evo2kvids")
                                    .fontWeight(.regular)
                                    .font(.system(size: 10))
                                    .foregroundColor(.black)
                                Text("74.4k")
                                    .fontWeight(.regular)
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                                Spacer()
                                
                                Button { } label: {
                                    Text("Subscribe")
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(
                                            Rectangle().fill(.black).cornerRadius(17)
                                        )
                                }
                            }
                            .padding(.all, 10)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach (0..<10) { i in
                                        Button { } label: {
                                        Text("Action_\(i)")
                                            .fontWeight(.regular)
                                            .font(.system(size:12))
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(
                                                Rectangle().fill(.gray.opacity(0.15)).cornerRadius(17)
                                            )
                                        }
                                    }
                                }
                            }
                            .padding(.leading, 10)
                            .padding(.bottom, 20)
                            
                            ForEach(0..<10) { _ in
                                VStack(spacing:0) {
                                    Image("demo")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: proxy.size.width, height: proxy.size.width * 0.5625)
                                        .clipped()
                                    HStack(spacing:0) {
                                        Image("demo")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .cornerRadius(15)
                                        Spacer(minLength: 0)
                                        VStack(alignment: .leading) {
                                            Text("EVO 2004: Daigo Umehara VS. Justin Wong - Alternate Viewpoint!")
                                                .fontWeight(.regular)
                                                .multilineTextAlignment(.leading)
                                                .font(.system(size: 13))
                                                .foregroundColor(.black)
                                            Text("MarkMan23・1.02M Views 4 years ago")
                                                .fontWeight(.regular)
                                                .font(.system(size: 10))
                                                .foregroundColor(.gray)
                                        }
                                        Spacer(minLength: 0)
                                        Image(systemName: "ellipsis")
                                            .rotationEffect(.degrees(90))
                                            .frame(width: 30)
                                    }
                                    .padding(.all, 10)
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.white)
                        .listRowInsets(.init())
                        .foregroundColor(.black)
                    }
                    .environment(\.defaultMinListRowHeight, 1)
                    .listStyle(.plain)
                    .background(.white)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .ignoresSafeArea(edges: orientation.isLandscape ? .all : [])
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
