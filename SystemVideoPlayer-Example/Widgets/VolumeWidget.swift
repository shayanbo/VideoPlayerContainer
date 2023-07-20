//
//  VolumeWidget.swift
//  SystemVideoPlayer-Example
//
//  Created by shayanbo on 2023/7/18.
//

import SwiftUI
import VideoPlayerContainer

class VolumeWidgetService : Service {
    
    @StateSync(serviceType: StatusService.self, keyPath: \.$status) fileprivate var status
    
    @ViewState fileprivate var volume: Float = 1 {
        didSet {
            let player = context[RenderService.self].player
            player.volume = volume
        }
    }
    
    @ViewState fileprivate var mute = false {
        didSet {
            let player = context[RenderService.self].player
            player.isMuted = mute
        }
    }
    
    fileprivate var volumeBinding: Binding<Float> {
        Binding {
            self.volume
        } set: {
            self.volume = $0
        }
    }
}

struct VolumeWidget: View {
    var body: some View {
        WithService(VolumeWidgetService.self) { service in
            HStack {
                if service.status == .fullScreen {
                    Slider(value: service.volumeBinding, clickable: true)
                        .frame(width: 100)
                }
                Group {
                    if service.volume == 0 || service.mute {
                        Image(systemName: "speaker.slash.fill")
                    } else if service.volume < 0.25 {
                        Image(systemName: "speaker.fill")
                    } else if service.volume < 0.5 {
                        Image(systemName: "speaker.wave.1.fill")
                    } else if service.volume < 7.5 {
                        Image(systemName: "speaker.wave.2.fill")
                    } else {
                        Image(systemName: "speaker.wave.3.fill")
                    }
                }
                .foregroundColor(.white)
                .onTapGesture {
                    service.mute.toggle()
                }
            }
        }
    }
}
