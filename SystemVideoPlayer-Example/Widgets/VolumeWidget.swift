//
//  VolumeWidget.swift
//  SystemVideoPlayer-Example
//
//  Created by shayanbo on 2023/7/18.
//

import SwiftUI
import Combine
import VideoPlayerContainer

fileprivate class VolumeWidgetService : Service {
    
    fileprivate var status: StatusService.Status?
    
    fileprivate var cancellables = [AnyCancellable]()
    
    required init(_ context: Context) {
        super.init(context)
        context[StatusService.self].$status.sink(receiveValue: { [weak self] status in
            self?.status = status
        }).store(in: &cancellables)
    }
    
    @ViewState var volume: Float = 1 {
        didSet {
            context?.render.player.volume = volume
        }
    }
    
    @ViewState var mute = false {
        didSet {
            context?.render.player.isMuted = mute
        }
    }
    
    var volumeBinding: Binding<Float> {
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
