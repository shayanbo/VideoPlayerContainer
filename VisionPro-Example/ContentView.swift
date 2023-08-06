//
//  ContentView.swift
//  VisionPro-Example
//
//  Created by shayanbo on 2023/8/5.
//

import SwiftUI
import VideoPlayerContainer
import AVKit

struct ContentView: View {
    
    /// create Context and let it have the same lifecycle with its enclosing underlying view
    /// Besides that the PlayerWidget makes the context accessible by its Widget,
    /// we need make it accessible by toolbar Widgets as well which is out of VideoPlayerContainer
    ///
    @StateObject var context = Context()

    var body: some View {
        PlayerWidget(context)
            .onAppear {
                guard let url = Bundle.main.url(forResource: "demo", withExtension: "mp4") else {
                    fatalError()
                }
                context.render.player.replaceCurrentItem(with: AVPlayerItem(url: url))
                context.render.player.play()
            }
            .toolbar {
                ToolbarItem(placement: .bottomOrnament) {
                    HStack {
                        
                        /// leading space
                        Spacer().frame(width: 10)

                        /// Widgets displaying current time
                        TimelineWidget()

                        /// Widgets displaying status of playback
                        PlaybackWidget()

                        /// Widgets displaying the progress of playing video
                        SeekBarWidget()

                        /// Widgets supporting change of video rate
                        RateWidget()

                        /// Widgets displaying duration
                        DurationWidget()

                        /// trailing space
                        Spacer().frame(width: 10)
                    }
                }
            }
            /// make it accessible inside toolbar Widgets
            .environmentObject(context)
    }
}

#Preview {
    ContentView()
}
