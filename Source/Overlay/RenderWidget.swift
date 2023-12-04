//
//  RenderWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/15.
//

import Foundation
import SwiftUI
import AVKit
#if os(iOS) || os(watchOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Service used by RenderWidget.
///
/// RenderService offers the AVPlayer to control over the playback, and AVPlayerLayer to control the detail of render.
/// It also support changing the default AVPlayer. This way, you can pass the AVPlayer from one Context to another.
///
public class RenderService : Service {
    
    /// AVPlayer instance.
    public private(set) var player = AVPlayer()
    
    /// AVPlayerLayer instance.
    public let layer = AVPlayerLayer()
    
    /// Change to another AVPlayer instance.
    /// - Parameter player: AVPlayer instance.
    ///
    public func attach(player: AVPlayer) {
        self.player = player
        layer.player = player
    }
}

struct RenderWidget : View {
    
    var body: some View {
        WithService(RenderService.self) { service in
            ZStack {
                RenderView(player: service.player, layer: service.layer)
                GestureWidget()
            }
        }
    }
}

#if os(iOS) || os(watchOS) || os(tvOS)

fileprivate struct RenderView : UIViewRepresentable {

    let player: AVPlayer
    let layer: AVPlayerLayer
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> PlayerView {
        let playerView = PlayerView()
        playerView.playerLayer = layer
        playerView.player = player
        return playerView
    }

    func updateUIView(_ uiView: PlayerView, context: UIViewRepresentableContext<Self>) { }
}

fileprivate class PlayerView: UIView {
    
    var player: AVPlayer? {
        didSet {
            if let canvas = self.layer.sublayers?.first as? AVPlayerLayer {
                canvas.player = player
            }
        }
    }
    
    var playerLayer: AVPlayerLayer? {
        didSet {
            self.layer.sublayers?.forEach {
                $0.removeFromSuperlayer()
            }
            guard let layer = playerLayer else {
                return
            }
            self.layer.addSublayer(layer)
            layer.player = player
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }
    
    deinit {
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
    }
}

#elseif os(macOS)

fileprivate struct RenderView : NSViewRepresentable {
    
    let player: AVPlayer
    let layer: AVPlayerLayer
    
    func makeNSView(context: NSViewRepresentableContext<Self>) -> PlayerView {
        let playerView = PlayerView()
        playerView.player = player
        playerView.playerLayer = layer
        return playerView
    }

    func updateNSView(_ uiView: PlayerView, context: NSViewRepresentableContext<Self>) { }
}

fileprivate class PlayerView: NSView {
    
    init() {
        super.init(frame: .zero)
        wantsLayer = true
    }
    
    override func makeBackingLayer() -> CALayer {
        CALayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var player: AVPlayer? {
        didSet {
            if let canvas = self.layer?.sublayers?.first as? AVPlayerLayer {
                canvas.player = player
            }
        }
    }
    
    var playerLayer: AVPlayerLayer? {
        didSet {
            self.layer?.sublayers?.forEach {
                $0.removeFromSuperlayer()
            }
            guard let layer = playerLayer else {
                return
            }
            self.layer?.addSublayer(layer)
            layer.player = player
            layer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        }
    }
    
    deinit {
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
    }
}

#endif

public extension Context {
    
    /// Simple alternative for `context[RenderService.self]`
    var render: RenderService {
        self[RenderService.self]
    }
}
