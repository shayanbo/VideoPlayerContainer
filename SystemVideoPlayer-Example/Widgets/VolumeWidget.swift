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
}

struct VolumeWidget: View {
    var body: some View {
        WithService(VolumeWidgetService.self) { service in
            HStack {
                if service.status == .fullScreen {
                    Rectangle()
                        .fill(.white)
                        .frame(width: 100, height: 5)
                        .cornerRadius(2)
                }
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundColor(.white)
            }
        }
    }
}
