//
//  PiPWidget.swift
//  SystemVideoPlayer-Example
//
//  Created by shayanbo on 2023/7/19.
//

import SwiftUI
import VideoPlayerContainer
import AVKit

class PiPWidgetService : Service {
    
    private var PiPController: AVPictureInPictureController?
    private var delegateObject: DelegateProxy?
    @ViewState fileprivate var isActive = false
    @ViewState fileprivate var isSupported = false
    
    required init(_ context: Context) {
        super.init(context)
        
        isSupported = AVPictureInPictureController.isPictureInPictureSupported()
        if !isSupported {
            return
        }
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        
        PiPController = AVPictureInPictureController(playerLayer: context[RenderService.self].layer)
        delegateObject = DelegateProxy()
        delegateObject?.willStart = { [weak context, weak self] in
            guard let context = context, let self = self else { return }
            self.isActive = true
            context[PluginService.self].present(.center) {
                AnyView(
                    Image(systemName: "pip")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 300, height: 300)
                )
            }
        }
        delegateObject?.didStop = { [weak context, weak self] in
            guard let context = context, let self = self else { return }
            self.isActive = false
            context[PluginService.self].dismiss()
        }
        PiPController?.delegate = delegateObject
    }
    
    fileprivate func didClick() {
        
        guard let controller = PiPController else {
            return
        }
        if controller.isPictureInPictureActive {
            controller.stopPictureInPicture()
        } else {
            controller.startPictureInPicture()
        }
    }
    
    private class DelegateProxy : NSObject, AVPictureInPictureControllerDelegate {
        
        var willStart: ( ()->Void )?
        var didStop: ( ()->Void )?
        
        func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            willStart?()
        }
        
        func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            didStop?()
        }
        
        func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
            completionHandler(true)
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
