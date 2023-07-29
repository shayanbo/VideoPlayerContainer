//
//  ReviewWidget.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/7/26.
//

import SwiftUI
import VideoPlayerContainer

fileprivate class MessageWidgetService: Service {
    
    func launchComments() {
        context[FeatureService.self].present(.right(.squeeze(0))) {
            AnyView(CommentWidget())
        }
    }
}

struct MessageWidget: View {
    var body: some View {
        WithService(MessageWidgetService.self) { service in
            Image(systemName: "ellipsis.message")
                .frame(width: 25, height: 35).foregroundColor(.white)
                .allowsHitTesting(true)
                .onTapGesture {
                    service.launchComments()
                }
        }
    }
}
