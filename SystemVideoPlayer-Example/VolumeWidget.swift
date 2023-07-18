//
//  VolumeWidget.swift
//  SystemVideoPlayer-Example
//
//  Created by shayanbo on 2023/7/18.
//

import SwiftUI
import VideoPlayerContainer

class VolumeService : Service {
    
    @StateSync(serviceType: StatusService.self, keyPath: \.$status) fileprivate var status
}

struct VolumeWidget: View {
    var body: some View {
        WithService(VolumeService.self) { service in
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
