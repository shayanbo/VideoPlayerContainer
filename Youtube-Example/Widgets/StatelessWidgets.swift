//
//  StatelessWidgets.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/7/26.
//

import SwiftUI

struct MinimizeWidget: View {
    var body: some View {
        Image(systemName: "chevron.down").frame(width: 25, height: 35).foregroundColor(.white)
    }
}

struct FullscreenWidget: View {
    var body: some View {
        Image(systemName: "arrow.down.right.and.arrow.up.left").foregroundColor(.white)
    }
}

struct CameraWidget: View {
    var body: some View {
        Image(systemName: "video.badge.ellipsis").frame(width: 25, height: 35).foregroundColor(.white)
    }
}

struct MoreWidget: View {
    var body: some View {
        Image(systemName: "ellipsis").frame(width: 25, height: 35).foregroundColor(.white)
    }
}

struct ShareWidget: View {
    var body: some View {
        Image(systemName: "arrowshape.turn.up.right").frame(width: 25, height: 35).foregroundColor(.white)
    }
}

struct WatchLaterWidget: View {
    var body: some View {
        Image(systemName: "plus.rectangle.on.rectangle").frame(width: 25, height: 35).foregroundColor(.white)
    }
}

struct ThumbDownWidget: View {
    var body: some View {
        Image(systemName: "hand.thumbsdown").frame(width: 25, height: 35).foregroundColor(.white)
    }
}

struct SpacerWidget: View {
    let space: CGFloat?
    init(_ space: CGFloat? = nil) {
        self.space = space
    }
    var body: some View {
        Spacer().frame(width: space)
    }
}

struct ToggleWidget: View {
    @State var toggle = false
    var body: some View {
        Toggle("", isOn: $toggle).fixedSize().frame(width: 50)
    }
}

struct WhateverWidget: View {
    var body: some View {
        Image(systemName: "square.on.square").frame(width: 25, height: 25).foregroundColor(.white)
    }
}

struct ReviewWidget: View {
    var body: some View {
        Image(systemName: "captions.bubble").frame(width: 25, height: 35).foregroundColor(.white)
    }
}

struct SwitchWidget: View {
    var body: some View {
        Image(systemName: "switch.2").frame(width: 25, height: 35).foregroundColor(.white)
    }
}

struct AirplayWidget: View {
    var body: some View {
        Image(systemName: "airplayvideo").frame(width: 25, height: 35).foregroundColor(.white)
    }
}

struct TitleWidget: View {
    var body: some View {
        Text("Michael Jackson - Thriller (Official 4K Video)").lineLimit(1).foregroundColor(.white)
    }
}

struct SettingsWidget: View {
    var body: some View {
        Image(systemName: "gearshape").frame(width: 25, height: 35).foregroundColor(.white)
    }
}

struct ThumbUpWidget: View {
    var body: some View {
        Image(systemName: "hand.thumbsup").frame(width: 25, height: 35).foregroundColor(.white)
    }
}
