//
//  MoreButtonWidget.swift
//  PlayerView
//
//  Created by shayanbo on 2023/6/23.
//

import SwiftUI

struct MoreButtonWidget: View {
    var body: some View {
        WithService(MoreButtonService.self) { service in
            Image(systemName: "ellipsis")
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

