//
//  FeedsViewModel.swift
//  VideoNavigation-Example
//
//  Created by shayanbo on 2023/7/21.
//

import Foundation
import VideoPlayerContainer
import SwiftUI

class FeedsViewModel : ObservableObject {
    
    //MARK: Navigation
    
    @Published var navigator = NavigationPath()
    
    var navigatorBinding: Binding<NavigationPath> {
        Binding {
            self.navigator
        } set: {
            self.navigator = $0
        }
    }
    
    func push(_ video: Video) {
        navigator.append(video)
    }
    
    //MARK: Search
    
    @Published var searchText = ""
    
    var searchTextBinding: Binding<String> {
        Binding {
            self.searchText
        } set: {
            self.searchText = $0
        }
    }
    
    //MARK: Video Data
    
    @Published var videos = [Video]()
    
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
    
    //MARK: Context
    
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
    
    //MARK: Active Video
    
    var activeVideo: Video?
}
