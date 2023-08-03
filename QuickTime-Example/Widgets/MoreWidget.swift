//
//  PlaylistEntranceWidget.swift
//  QuickTime-Example
//
//  Created by shayanbo on 2023/8/3.
//

import SwiftUI
import VideoPlayerContainer

fileprivate class MoreWidgetService: Service {
    
    func showPlaylist() {
        let featureService = context[FeatureService.self]
        featureService.present(.right(.cover)) {
            AnyView(PlaylistWidget())
        }
    }
}

struct MoreWidget: View {
    var body: some View {
        WithService(MoreWidgetService.self) { service in
            Button {
                service.showPlaylist()
            } label: {
                Image(systemName: "list.clipboard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .opacity(0.7)
            }
            .buttonStyle(.plain)
        }
    }
}
