//
//  BackWidget.swift
//  VideoNavigation-Example
//
//  Created by shayanbo on 2023/7/21.
//

import SwiftUI
import VideoPlayerContainer

class BackWidgetService : Service {
    
    typealias Handler = ()->Void
}

struct BackWidget: View {
    
    @Environment(\.dismiss) fileprivate var dismiss
    
    var body: some View {
        WithService(BackWidgetService.self) { service in
            Image(systemName: "chevron.backward")
                .frame(width: 25, height: 35)
                .contentShape(Rectangle())
                .foregroundColor(.white)
                .onTapGesture {
                    dismiss()
                }
        }
    }
}
