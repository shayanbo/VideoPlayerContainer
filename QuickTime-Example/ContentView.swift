//
//  ContentView.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/13.
//

import SwiftUI
import AVKit
import VideoPlayerContainer
import Combine

struct ContentView: View {
    
    /// create Context and let it have the same lifecycle with its enclosing underlying view
    @StateObject var context = Context()
    
    /// user-selected video file URL
    @State var current: String?
    
    var body: some View {
        
        Group {
            if let fileName = current {
                PlayerWidget(context)
                    /// make the VideoPlayerContainer full up the window
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        
                        /// only enable the render overlay (remove other default overlays)
                        context.container.enable(overlays: [.render, .plugin, .feature])
                        
                        /// insert a custom overlay at the location above the original Control overlay
                        /// this custom overlay is the float panel you can see in the system builtin macOS QuickTime
                        context.container.configure(overlay: .control) {
                            AnyView(FloatControlOverlay())
                        }
                        
                        /// add widgets to the custom overlay
                        context.floatControl.configure(.first) {[
                            VolumeWidget(),
                            Spacer(),
                            StepBackWidget(),
                            PlaybackWidget(),
                            StepForwardWidget(),
                            Spacer(),
                            PiPWidget(),
                            ShareWidget(),
                            MoreWidget(),
                        ]}
                        context.floatControl.configure(.second) {[
                            TimelineWidget(),
                            SeekBarWidget(),
                            DurationWidget(),
                        ]}
                    }
                    /// display the name of playing video as the title of window
                    .navigationTitle(fileName)
            } else {
                ZStack {
                    Rectangle().fill(.black)
                    Text("Drag Video File Here")
                        .font(.system(size: 60))
                }
            }
        }
        /// sync state from context' service to make current view refresh when the state changes
        .onReceive(context[PlaylistWidgetService.self][keyPath: \.$current]) { output in
            self[keyPath:\.current] = output
        }
        /// users can play the video by drag and drop
        .onDrop(of: ["public.file-url"], isTargeted: nil) { providers in
            providers.forEach { provider in
                _ = provider.loadObject(ofClass: URL.self) { url, _ in
                    guard let url else {
                        return
                    }
                    guard let ut = try? url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier else {
                        return
                    }
                    if ut == "com.apple.quicktime-movie" || ut == "public.mpeg-4" {
                        DispatchQueue.main.async {
                            context[PlaylistWidgetService.self].play(url)
                        }
                    }
                }
            }
            return true
        }
        .colorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

