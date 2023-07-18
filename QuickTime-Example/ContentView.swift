//
//  ContentView.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/13.
//

import SwiftUI
import AVKit
import VideoPlayerContainer

struct ContentView: View {
    
    @StateObject var context = Context()
    
    @ObservedObject var menuViewModel = MenuViewModel.shared
    
    @State var fileURL: URL?
    
    var body: some View {
        
        Group {
            if let url = fileURL {
                PlayerWidget(context, launch: [LoadingService.self])
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                    
                        let playerService = context[PlayerService.self]
                        playerService.enable(overlays: [.render, .feature])
                        playerService.configure(overlay: .control) {
                            AnyView(FloatControlOverlay())
                        }
                        
                        let controlService = context[FloatControlService.self]
                        controlService.configure(.first) {[
                            VolumeWidget(),
                            Spacer(),
                            StepBackWidget(),
                            PlaybackButtonWidget(),
                            StepForwardWidget(),
                            Spacer(),
                            PiPWidget(),
                            ShareWidget(),
                            MoreWidget(),
                        ]}
                        controlService.configure(.second) {[
                            TimelineWidget(),
                            SeekBarWidget(),
                            DurationWidget(),
                        ]}
                        
                        let player = context[RenderService.self].player
                        let item = AVPlayerItem(url: url)
                        player.replaceCurrentItem(with: item)
                        player.play()
                    }
                    .navigationTitle(url.lastPathComponent)
            } else {
                ZStack {
                    Rectangle().fill(.black)
                    Text("⌘+O")
                        .font(.system(size: 60))
                        .onTapGesture {
                            self.menuViewModel.isOpenFilePresented.toggle()
                        }
                }
            }
        }
        .fileImporter(isPresented: $menuViewModel.isOpenFilePresented, allowedContentTypes: [
            .quickTimeMovie, .mpeg, .mpeg2Video, .mpeg4Movie
        ]) { result in
            if case let .success(url) = result {
                self.fileURL = url
            }
        }
        .colorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

