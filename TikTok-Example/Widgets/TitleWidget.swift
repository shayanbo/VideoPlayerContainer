//
//  TitleWidget.swift
//  TikTok-Example
//
//  Created by shayanbo on 2023/7/16.
//

import SwiftUI
import VideoPlayerContainer

fileprivate class TitleService: Service {
    
    var title: String {
        "@\(context[DataService.self].author ?? "--")"
    }
}

struct TitleWidget: View {
    var body: some View {
        
        WithService(TitleService.self) { service in
            Text(service.title)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
    }
}
