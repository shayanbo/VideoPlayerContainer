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
    
    @StateObject var vm = FeedsViewModel()
    
    @State var path = NavigationPath()
    
    @State var searchText = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            List(vm.videos) { video in
                VStack {
                    
                    HStack {
                        AsyncImage(url: URL(string: video.avatarUrl)!) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        
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
                            .frame(width: 200, height: 200)
                            .onAppear {
                                let context = vm.context(video: video)
                                let controlService = context[ControlService.self]
                                
                                controlService.configure(displayStyle: .always)
                                controlService.configure(.halfScreen, insets: .init(top: 0, leading: 5, bottom: 10, trailing: 5))
                                controlService.configure(.halfScreen(.bottom1)) {[
                                    CountdownWidget(),
                                    Spacer(),
                                    PlaybackWidget()
                                ]}
                                
                                let player = context[RenderService.self].player
                                let item = AVPlayerItem(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)
                                player.replaceCurrentItem(with: item)
                                player.play()
                            }
                            .onDisappear {
                                let context = vm.context(video: video)
                                let player = context[RenderService.self].player
                                player.pause()
                            }
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
                            
                            Spacer()
                        }
                        
                        VStack(alignment: .leading) {
                            Text(video.topComment.author)
                                .font(.system(size:14))
                                .foregroundColor(.gray)
                                .fontWeight(.light)
                            Text(video.topComment.comment)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.system(size:15))
                                .fontWeight(.light)
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Label("\(video.topComment.likes)", systemImage: "suit.heart")
                            .labelStyle(CommentStyle())
                    }
                    .padding(.horizontal, 15)
                    
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: 10)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(PlainListStyle())
        }
        .searchable(text: $searchText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
