//
//  BackButtonWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/23.
//

import SwiftUI
import VideoPlayerContainer

struct BackButtonWidget: View {
    var body: some View {
        WithService(BackButtonService.self) { service in
            Image(systemName: "chevron.backward")
                .onTapGesture {
                    service.didClick()
                }
        }
    }
}

class BackButtonService : Service {
    
    private var clickHandler: (()->Void)?
    
    fileprivate func didClick() {
        clickHandler?()
    }
    
    func bindClickHandler(_ handler: @escaping ()->Void) {
        clickHandler = handler
    }
}
