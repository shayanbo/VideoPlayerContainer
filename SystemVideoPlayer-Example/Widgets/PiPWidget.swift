//
//  PiPWidget.swift
//  SystemVideoPlayer-Example
//
//  Created by shayanbo on 2023/7/19.
//

import SwiftUI
import VideoPlayerContainer
import AVKit

fileprivate class PiPWidgetService : Service {
    
    private var PiPController: AVPictureInPictureController?
    private var activeObservation: NSKeyValueObservation?
    
    @ViewState var isActive = false
    @ViewState var isSupported = false
    
    required init(_ context: Context) {
        super.init(context)
        
        isSupported = AVPictureInPictureController.isPictureInPictureSupported()
        if !isSupported {
            return
        }
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        
        PiPController = AVPictureInPictureController(playerLayer: context[RenderService.self].layer)
        
        activeObservation = PiPController?.observe(\.isPictureInPictureActive, options: [.old, .new, .initial]) { [weak self] controller, change in
            self?.isActive = controller.isPictureInPictureActive
        }
    }
    
    func didClick() {
        guard let controller = PiPController else {
            return
        }
        context[ControlService.self].dismiss()
        
        if controller.isPictureInPictureActive {
            controller.stopPictureInPicture()
        } else {
            controller.startPictureInPicture()
        }
    }
}

struct PiPWidget: View {
    var body: some View {
        WithService(PiPWidgetService.self) { service in
            Image(systemName: service.isActive ? "pip.exit" : "pip.enter")
                .foregroundColor(service.isSupported ? .white : .gray)
                .allowsHitTesting(service.isSupported)
                .onTapGesture {
                    service.didClick()
                }
        }
    }
}
