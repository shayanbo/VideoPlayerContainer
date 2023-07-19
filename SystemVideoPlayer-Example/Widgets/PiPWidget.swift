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
    private var PiPControllerDelegate: Delegate?
    
    required init(_ context: Context) {
        super.init(context)
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        
        PiPController = AVPictureInPictureController(playerLayer: context[RenderService.self].layer)
        PiPControllerDelegate = Delegate(context)
        PiPController?.delegate = PiPControllerDelegate
    }
    
    fileprivate func startPiP() {
        PiPController?.startPictureInPicture()
    }
    
    class Delegate : NSObject, AVPictureInPictureControllerDelegate {
        
        weak var context: Context?
        
        init(_ context: Context) {
            self.context = context
        }
        
        func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            guard let context = context else { return }
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
        
        func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            guard let context = context else { return }
            context[PluginService.self].dismiss()
        }
        
        func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
            completionHandler(true)
        }
    }
}

struct PiPWidget: View {
    var body: some View {
        WithService(PiPWidgetService.self) { service in
            Image(systemName: "pip.enter")
                .foregroundColor(.white)
                .onTapGesture {
                    service.startPiP()
                }
        }
    }
}
