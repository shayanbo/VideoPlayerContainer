//
//  DescriptionWidget.swift
//  TikTok-Example
//
//  Created by shayanbo on 2023/7/16.
//

import SwiftUI
import VideoPlayerContainer

fileprivate class DescriptionService: Service {
    
    var description: String {
        context[DataService.self].description ?? "--"
    }
}

struct DescriptionWidget: View {
    var body: some View {
        
        WithService(DescriptionService.self) { service in
            Text(service.description)
                .fontWeight(.regular)
                .foregroundColor(.white)
        }
    }
}
