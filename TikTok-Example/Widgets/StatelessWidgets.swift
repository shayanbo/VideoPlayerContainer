//
//  StatelessWidgets.swift
//  TikTok-Example
//
//  Created by shayanbo on 2023/7/26.
//

import SwiftUI

struct LikeWidget: View {
    var body: some View {
        Image(systemName: "heart.fill").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30)
    }
}

struct ProfileWidget: View {
    var body: some View {
        Image(systemName: "person.fill.badge.plus").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30)
    }
}

struct FavorWidget: View {
    var body: some View {
        Image(systemName: "star.fill").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30)
    }
}

struct ShareWidget: View {
    var body: some View {
        Image(systemName: "arrowshape.turn.up.right.fill").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30)
    }
}

struct AlbumWidget: View {
    var body: some View {
        Image(systemName: "circle.fill").resizable().foregroundColor(.white).scaledToFit().frame(width: 30, height: 30)
    }
}

struct SpacerWidget: View {
    
    let width: CGFloat?
    let height: CGFloat?
    
    init(width: CGFloat? = nil, height: CGFloat? = nil) {
        self.width = width
        self.height = height
    }
    var body: some View {
        Spacer().frame(width: width, height: height)
    }
}
