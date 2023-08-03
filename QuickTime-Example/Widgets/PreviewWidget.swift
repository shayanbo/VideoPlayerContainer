//
//  PreviewWidget.swift
//  QuickTime-Example
//
//  Created by shayanbo on 2023/8/3.
//

import SwiftUI
import VideoPlayerContainer

class PreviewWidgetService: Service {
    
    @ViewState var previewImage: CGImage?
    @ViewState var displaySize: CGSize = .zero
    @ViewState var offset: CGSize = .zero
}

struct PreviewWidget: View {
    var body: some View {
        WithService(PreviewWidgetService.self) { service in
            if let preview = service.previewImage {
                Image(preview, scale: 1.0, label: Text("Preview"))
                    .resizable()
                    .frame(width: service.displaySize.width, height: service.displaySize.height)
                    .cornerRadius(5)
                    .offset(service.offset)
            }
        }
    }
}
