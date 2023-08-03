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
    
    fileprivate var fileDir: String? {
        guard let current = current else {
            return nil
        }
        return (current as NSString).deletingLastPathComponent
    }
    
    @ViewState fileprivate var current: String? {
        didSet {
            /// play the user-selected video from the local file system
            let player = context[RenderService.self].player
            if let current = current, let encodedCurrent = current.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                let item = AVPlayerItem(url: URL(string: "file://\(encodedCurrent)")!)
                player.replaceCurrentItem(with: item)
                player.play()
            } else {
                player.replaceCurrentItem(with: nil)
            }
        }
    }
    
    fileprivate func isCurrent(_ file: String) -> Bool {
        guard let current = current else {
            return false
        }
        return file == (current as NSString).lastPathComponent
    }
    
    func play(_ url: URL) {
        self.current = url.path(percentEncoded: true)
    }
    
    fileprivate func `switch`(_ fileName: String) {
        guard let fileDir = fileDir else {
            return
        }
        self.current = "\(fileDir)/\(fileName)"
    }
    
    fileprivate var fileNames: [String] {
        guard let fileDir = fileDir else {
            return []
        }
        do {
            return try FileManager.default.contentsOfDirectory(atPath: fileDir).filter { path in
                guard let url = URL(string: "file://\(fileDir)/\(path)") else {
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
}

extension String : Identifiable {
    public var id: String {
        self
    }
}

struct PlaylistWidget: View {
    var body: some View {
        WithService(PlaylistWidgetService.self) { service in
            VStack {
                Text("Playlist")
                    .padding(.top, 10)
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
                    }
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
