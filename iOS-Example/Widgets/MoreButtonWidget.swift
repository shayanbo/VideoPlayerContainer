//
//  MoreButtonWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/23.
//

import SwiftUI
import VideoPlayerContainer

struct MoreButtonWidget: View {
    var body: some View {
        WithService(MoreButtonService.self) { service in
            Image(systemName: "ellipsis")
                .frame(width: 25, height: 25)
                .contentShape(Rectangle())
                .onTapGesture {
                    service.didClick()
                }
        }
    }
}

class MoreButtonService : Service {
    
    private var clickHandler: (()->Void)?
    
    fileprivate func didClick() {
        clickHandler?()
    }
    
    func bindClickHandler(_ handler: @escaping ()->Void) {
        clickHandler = handler
    }
}

