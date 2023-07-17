//
//  VolumeWidget.swift
//  QuickTime-Example
//
//  Created by shayanbo on 2023/7/17.
//

import SwiftUI
import VideoPlayerContainer

class VolumeService : Service {
    
    @ViewState fileprivate var slideValue: Float = 1.0 {
        didSet {
            let player = context[RenderService.self].player
            player.volume = slideValue
        }
    }
}

struct VolumeWidget: View {
    var body: some View {
        WithService(VolumeService.self) { service in
            Slider(value: Binding(get: {
                service.slideValue
            }, set: {
                service.slideValue = $0
            })) {
                Group {
                    if service.slideValue == 0 {
                        Image(systemName: "speaker.slash.fill")
                    } else if service.slideValue < 0.25 {
                        Image(systemName: "speaker.fill")
                    } else if service.slideValue < 0.5 {
                        Image(systemName: "speaker.wave.1.fill")
                    } else if service.slideValue < 7.5 {
                        Image(systemName: "speaker.wave.2.fill")
                    } else {
                        Image(systemName: "speaker.wave.3.fill")
                    }
                }.opacity(0.7)
            }
            .frame(width: 100)
        }
    }
}

