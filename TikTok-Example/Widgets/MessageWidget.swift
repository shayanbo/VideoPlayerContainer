//
//  MessageWidget.swift
//  TikTok-Example
//
//  Created by shayanbo on 2023/7/16.
//

import SwiftUI
import VideoPlayerContainer

fileprivate class MesssageService: Service {
    
    func onClick() {
        context[FeatureService.self].present(.bottom(.squeeze(0))) { [weak context] in
            context?.control.dismiss()
        } beforeDismiss: { [weak context] in
            context?.control.present()
        } content: {
            AnyView(
                Form {
                    ForEach(self.context[DataService.self].comments ?? [], id: \.self) { comment in
                        Text(comment)
                    }
                }.frame(height: 400)
            )
        }
    }
}

struct MessageWidget: View {
    var body: some View {
        
        WithService(MesssageService.self) { service in
            Image(systemName: "ellipsis.message.fill")
                .resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30)
                .allowsHitTesting(true)
                .onTapGesture {
                    service.onClick()
                }
        }
    }
}
