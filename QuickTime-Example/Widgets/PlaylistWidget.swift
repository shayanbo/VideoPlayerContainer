//
//  PlaylistWidget.swift
//  QuickTime-Example
//
//  Created by shayanbo on 2023/8/3.
//

import SwiftUI
import VideoPlayerContainer
import AVKit

class PlaylistWidgetService: Service {
    
    /// Current directory
    fileprivate var fileDir: String?
    
    /// Current fileName
    @ViewState fileprivate var current: String? {
        didSet {
            /// play the user-selected video from the local file system
            let player = context[RenderService.self].player
            if let current, let fileDir {
                let item = AVPlayerItem(url: URL(string: "file://\(transform("\(fileDir)/\(current)"))")!)
                player.replaceCurrentItem(with: item)
                player.play()
            } else {
                player.replaceCurrentItem(with: nil)
            }
        }
    }
    
    private var token: NSObjectProtocol?
    
    required init(_ context: Context) {
        super.init(context)

        /// Play next automatically
        token = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self] _ in

            guard let self, let current else {
                return
            }
            guard let index = self.fileNames.firstIndex(of: current) else {
                return
            }
            guard index < self.fileNames.count - 1 else {
                return
            }
            
            let next = self.fileNames[index+1]
            self.switch(next)
        }
    }
    
    fileprivate func isCurrent(_ file: String) -> Bool {
        guard let current = current else {
            return false
        }
        return file == current
    }
    
    func play(_ url: URL) {
        let originalPath = url.path(percentEncoded: false)
        fileDir = (originalPath as NSString).deletingLastPathComponent
        current = (originalPath as NSString).lastPathComponent
    }
    
    /// Switch video
    fileprivate func `switch`(_ fileName: String) {
        self.current = fileName
    }
    
    fileprivate var fileNames: [String] {
        guard let fileDir = fileDir else {
            return []
        }
        do {
            return try FileManager.default.contentsOfDirectory(atPath: fileDir).filter { fileName in
                guard let url = URL(string: "file://\(transform("\(fileDir)/\(fileName)"))") else {
                    return false
                }
                guard let ut = try? url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier else {
                    return false
                }
                return ut == "com.apple.quicktime-movie" || ut == "public.mpeg-4"
            }
        } catch {
            return []
        }
    }
    
    private func transform(_ path: String) -> String {
        path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? path
    }
}

extension String : Identifiable {
    public var id: String {
        self
    }
}

struct PlaylistWidget: View {
    var body: some View {
        WithService(PlaylistWidgetService.self) { service in
            VStack(spacing: 0) {
                Text("Playlist")
                    .padding(.vertical, 10)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                
                Divider()
                
                List(service.fileNames) { fileName in
                    HStack {
                        Image(systemName: "arrowtriangle.right.fill")
                            .opacity(service.isCurrent(fileName) ? 1.0 : 0.0)
                        Text(
                            fileName
                        )
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.visible)
                    .listRowSeparatorTint(.white.opacity(0.2))
                    .onTapGesture(count: 2) {
                        service.`switch`(fileName)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .frame(width: 300)
            .background(.thinMaterial)
        }
    }
}
