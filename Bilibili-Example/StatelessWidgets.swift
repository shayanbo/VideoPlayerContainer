//
//  StatelessWidgets.swift
//  Bilibili-Example
//
//  Created by shayanbo on 2023/7/26.
//

import SwiftUI

struct PlaybackWidget: View {
    var body: some View {
        Image(systemName: "play.fill")
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
    }
}

struct DanmakuWidget: View {
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.white)
                .cornerRadius(10)
                .frame(height: 40)
            Text("发个友善的弹幕见证当下")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.leading, 20)
        }
    }
}

struct BackWidget: View {
    var body: some View {
        Image(systemName: "chevron.left").foregroundColor(.white).frame(width: 30, height: 30)
    }
}

struct SpacerWidget: View {
    var body: some View {
        Spacer()
    }
}

struct MusicWidget: View {
    var body: some View {
        Image(systemName: "music.quarternote.3").foregroundColor(.white).frame(width: 30, height: 30)
    }
}

struct AirplayWidget: View {
    var body: some View {
        Image(systemName: "airplayvideo").foregroundColor(.white).frame(width: 30, height: 30)
    }
}

struct MoreWidget: View {
    var body: some View {
        Image(systemName: "ellipsis").foregroundColor(.white).frame(width: 30, height: 30).rotationEffect(.degrees(90))
    }
}

struct FullscreenWidget: View {
    var body: some View {
        Image(systemName: "arrow.up.left.and.arrow.down.right").frame(width: 30, height: 30).foregroundColor(.white)
    }
}

struct ClockWidget: View {
    var body: some View {
        Text("12:12").foregroundColor(.white)
    }
}

struct NetworkWidget: View {
    var body: some View {
        Image(systemName: "wifi").foregroundColor(.white)
    }
}

struct BatteryWidget: View {
    var body: some View {
        Image(systemName: "battery.75").foregroundColor(.white)
    }
}

struct TitleWidget: View {
    var body: some View {
        Text("Michael Jackson - Thriller (Official 4K Video)").foregroundColor(.white)
    }
}

struct ThumbUpWidget: View {
    var body: some View {
        Image(systemName: "hand.thumbsup").foregroundColor(.white).frame(width: 30, height: 30)
    }
}

struct ThumbDownWidget: View {
    var body: some View {
        Image(systemName: "hand.thumbsdown").foregroundColor(.white).frame(width: 30, height: 30)
    }
}

struct CoinWidget: View {
    var body: some View {
        Image(systemName: "bitcoinsign.circle").foregroundColor(.white).frame(width: 30, height: 30)
    }
}

struct ChargeWidget: View {
    var body: some View {
        Image(systemName: "battery.100.bolt").foregroundColor(.white).frame(width: 30, height: 30).rotationEffect(.degrees(90))
    }
}

struct ShareWidget: View {
    var body: some View {
        Image(systemName: "arrowshape.turn.up.right").foregroundColor(.white).frame(width: 30, height: 30)
    }
}

struct GiftWidget: View {
    var body: some View {
        Image(systemName: "gift.fill").foregroundColor(.white).frame(width: 30, height: 30)
    }
}

struct SnapshotWidget: View {
    var body: some View {
        Image(systemName: "camera.fill").foregroundColor(.white).frame(width: 30, height: 30)
    }
}

struct FollowWidget: View {
    var body: some View {
        Button("+关注") {}
            .foregroundColor(.white)
            .cornerRadius(3)
            .buttonStyle(.borderedProminent)
            .padding(.top, 10)
    }
}

struct CaptionWidget: View {
    var body: some View {
        Text("字幕").font(.subheadline).foregroundColor(.white)
    }
}

struct SpeedWidget: View {
    var body: some View {
        Text("倍速").font(.subheadline).foregroundColor(.white)
    }
}

struct QualityWidget: View {
    var body: some View {
        Text("自动").font(.subheadline).foregroundColor(.white)
    }
}

struct WhateverWidget1: View {
    var body: some View {
        Image(systemName: "square.text.square.fill").foregroundColor(.white).frame(width: 30, height: 30)
    }
}

struct WhateverWidget2: View {
    var body: some View {
        Image(systemName: "heart.text.square.fill").foregroundColor(.white).frame(width: 30, height: 30)
    }
}
