//
//  ContentView.swift
//  VideoNavigation-Example
//
//  Created by shayanbo on 2023/7/21.
//

import SwiftUI
import AVKit
import VideoPlayerContainer

struct ContentView: View {
    
    @StateObject private var vm = FeedsViewModel()
    
    private let listCoordinateSpaceName = UUID().uuidString
    
    var body: some View {
        NavigationStack(path: vm.navigatorBinding) {
            GeometryReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(vm.videos) { video in
                            HStack {
                                AsyncImage(url: URL(string: video.avatarUrl)!) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().strokeBorder(.gray.opacity(0.3), lineWidth: 1)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(video.author)
                                    Text(video.date)
                                        .font(.system(size:12))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "ellipsis")
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 15)
                            
                            HStack {
                                Text(video.desc)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            .padding(.horizontal, 15)
                            
                            HStack {
                                PlayerWidget(vm.context(video: video))
                                    .background(.gray)
                                    .cornerRadius(10)
                                    .frame(width: 200, height: 200 / video.aspectRatio)
                                    .onAppear {
                                        let context = vm.context(video: video)
                                        let controlService = context[ControlService.self]
                                        let gestureService = context[GestureService.self]
                                        
                                        gestureService.simultaneousTapGesture = SpatialTapGesture()
                                            .onEnded { _ in
                                                vm.push(video)
                                                vm.activeVideo = video
                                            }
                                        
                                        controlService.configure(displayStyle: .always)
                                        controlService.configure(.halfScreen, insets: .init(top: 0, leading: 5, bottom: 10, trailing: 5))
                                        controlService.configure(.halfScreen(.bottom1)) {[
                                            CountdownWidget(),
                                            Spacer(),
                                            PlaybackWidget()
                                        ]}
                                    }
                                    .background(
                                        GeometryReader {proxy in
                                            Color.clear.videoFrameProvider(video: video, frame: proxy.frame(in: .named(listCoordinateSpaceName)))
                                        }
                                    )
                                Spacer()
                            }
                            .padding(.horizontal, 15)
                            
                            HStack {
                                Label("\(video.likes)", systemImage: "suit.heart")
                                    .labelStyle(ActionStyle())
                                    .padding(.trailing, 20)
                                Label("\(video.comments)", systemImage:"ellipsis.message")
                                    .labelStyle(ActionStyle())
                                    .padding(.trailing, 20)
                                Label("\(video.favors)", systemImage:"star")
                                    .labelStyle(ActionStyle())
                                    .padding(.trailing, 20)
                                Label("\(video.shares)", systemImage:"arrowshape.turn.up.right")
                                    .labelStyle(ActionStyle())
                                    .padding(.trailing, 20)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                            
                            HStack {
                                
                                VStack {
                                    AsyncImage(url: URL(string: video.avatarUrl)!) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle().strokeBorder(.gray.opacity(0.3), lineWidth: 1)
                                    }
                                    
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(video.topComment.author)
                                        .font(.system(size:13))
                                        .foregroundColor(.gray)
                                        .fontWeight(.light)
                                    Text(video.topComment.comment)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size:14))
                                        .fontWeight(.light)
                                    Spacer()
                                }
                                
                                Spacer()
                                
                                Label("\(video.topComment.likes)", systemImage: "suit.heart")
                                    .labelStyle(CommentStyle())
                                    .padding(.leading, 10)
                            }
                            .padding(.horizontal, 15)
                            
                            Rectangle()
                                .fill(.gray.opacity(0.3))
                                .frame(height: 10)
                        }
                    }
                }
                .coordinateSpace(name: listCoordinateSpaceName)
                .navigationDestination(for: Video.self, destination: { video in
                    
                    let context = self.vm.context(video: video)
                    let renderService = context[RenderService.self]
                    let player = renderService.player
                    
                    VideoDetail(video: video, player: player)
                })
                .onPreferenceChange(VideoFramePreferenceKey.self) { videoFrames in
                    let listBounds = proxy.frame(in: .local)
                    
                    guard let videoFrame = videoFrames.sorted(by: { lhs, rhs in
                        let lhsExpose = listBounds.intersection(lhs.frame).height / lhs.frame.height
                        let rhsExpose = listBounds.intersection(rhs.frame).height / rhs.frame.height
                        return lhsExpose > rhsExpose
                    }).first else {
                        return
                    }
                    
                    vm.activeVideo = videoFrame.video
                }
            }
        }
        .searchable(text: vm.searchTextBinding)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
