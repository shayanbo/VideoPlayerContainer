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
    
    /// create Context and let it have the same lifecycle with its enclosing underlying view
    @StateObject var context = Context()
    
    @ObservedObject var menuViewModel = MenuViewModel.shared
    
    @State var fileURL: URL?
    
    var body: some View {
        
        Group {
            if let url = fileURL {
                PlayerWidget(context, launch: [LoadingService.self])
                    /// make the VideoPlayerContainer full up the window
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        
                        /// only enable the render overlay (remove other default overlays)
                        let playerService = context[PlayerService.self]
                        playerService.enable(overlays: [.render])
                        
                        /// insert a custom overlay at the location above the original Control overlay
                        /// this custom overlay is the float panel you can see in the system builtin macOS QuickTime
                        playerService.configure(overlay: .control) {
                            AnyView(FloatControlOverlay())
                        }
                        
                        /// add widgets to the custom overlay
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
                        
                        /// play the user-selected video from the local file system
                        let player = context[RenderService.self].player
                        let item = AVPlayerItem(url: url)
                        player.replaceCurrentItem(with: item)
                        player.play()
                    }
                    /// display the name of playing video as the title of window
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

