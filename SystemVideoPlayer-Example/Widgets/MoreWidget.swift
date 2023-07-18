//
//  MoreWidget.swift
//  SystemVideoPlayer-Example
//
//  Created by shayanbo on 2023/7/18.
//

import SwiftUI
import VideoPlayerContainer

class MoreWidgetService : Service {
    
    enum Rate: String, CaseIterable, Identifiable {
        case x0_5, x1_0, x1_25, x1_5, x2_0
        var id: Self { self }
    }
    
    @ViewState fileprivate var rate: Rate = .x1_0
}

struct MoreWidget: View {
    var body: some View {
        WithService(MoreWidgetService.self) { service in
            Menu {
                Picker(selection: Binding(get: {
                    service.rate
                }, set: {
                    service.rate = $0
                })) {
                    ForEach(MoreWidgetService.Rate.allCases) { rate in
                        Text(rate.rawValue)
                            .tag(service.rate)
                    }
                } label: {
                    Label("Playback Speed", systemImage: "gauge.high")
                }
            } label: {
                Image(systemName: "ellipsis.circle").foregroundColor(.white)
            }
        }
    }
}
