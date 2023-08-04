//
//  MoreWidget.swift
//  SystemVideoPlayer-Example
//
//  Created by shayanbo on 2023/7/18.
//

import SwiftUI
import VideoPlayerContainer

fileprivate class MoreWidgetService : Service {
    
    enum Rate: String, CaseIterable, Identifiable {
        case x0_5 = "0.5x"
        case x1_0 = "1.0x"
        case x1_25 = "1.25x"
        case x1_5 = "1.5x"
        case x2_0 = "2.0x"
        
        var id: Self { self }
        
        var float: Float {
            switch self {
            case .x0_5: return 0.5
            case .x1_0: return 1.0
            case .x1_25: return 1.25
            case .x1_5: return 1.5
            case .x2_0: return 2.0
            }
        }
    }
    
    @ViewState var rate: Rate = .x1_0 {
        didSet {
            context.render.player.rate = rate.float
        }
    }
    
    var rateBinding: Binding<Rate> {
        Binding { self.rate } set: { self.rate = $0 }
    }
}

struct MoreWidget: View {
    var body: some View {
        WithService(MoreWidgetService.self) { service in
            Menu {
                Picker(selection: service.rateBinding) {
                    ForEach(MoreWidgetService.Rate.allCases) { rate in
                        Text(rate.rawValue)
                    }
                } label: {
                    Label("Playback Speed", systemImage: "gauge.high")
                }
                .pickerStyle(.menu)
            } label: {
                Image(systemName: "ellipsis.circle").foregroundColor(.white)
            }
        }
    }
}
