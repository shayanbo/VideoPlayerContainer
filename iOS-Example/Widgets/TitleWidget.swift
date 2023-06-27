//
//  TitleWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/20.
//

import SwiftUI
import VideoPlayerContainer

struct TitleWidget: View {
    var body: some View {
        WithService(TitleService.self) { service in
            if let title = service.title {
                Text(title)
                    .frame(height:40)
            }
        }
    }
}

class TitleService : Service {
    
    @ViewState fileprivate var title: String?
    
    func setTitle(_ title: String) {
        self.title = title
    }
}
