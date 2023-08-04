//
//  VolumeWidget.swift
//  QuickTime-Example
//
//  Created by shayanbo on 2023/7/17.
//

import SwiftUI
import VideoPlayerContainer

fileprivate class VolumeWidgetService : Service {
    
    @ViewState var slideValue: Float = 1.0 {
        didSet {
            context.render.player.volume = slideValue
        }
    }
    
    var slideBinding: Binding<Float> {
        Binding {
            self.slideValue
        } set: {
            self.slideValue = $0
        }
    }
}

struct VolumeWidget: View {
    var body: some View {
        WithService(VolumeWidgetService.self) { service in
            Slider(value: service.slideBinding) {
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
            }
            .frame(width: 100)
            .tint(.white)
        }
    }
}

