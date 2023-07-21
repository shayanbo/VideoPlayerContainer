//
//  FeedsViewModel.swift
//  VideoNavigation-Example
//
//  Created by shayanbo on 2023/7/21.
//

import Foundation
import VideoPlayerContainer

class FeedsViewModel : ObservableObject {
    
    @Published var videos = [Video]()
    
    private var contexts = [Video: Context]()
    
    func context(video: Video) -> Context {
        if let context = contexts[video] {
            return context
        } else {
            let context = Context()
            contexts[video] = context
            return context
        }
    }
    
    init() {
        guard let feedsUrl = Bundle.main.url(forResource: "feeds", withExtension: "json") else {
            return
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = try? Data(contentsOf: feedsUrl) else {
            return
        }
        
        do {
            self.videos = try decoder.decode([Video].self, from: data)
        } catch {
            print(error)
        }
    }
}
