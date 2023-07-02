//
//  PlaybackWidget.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/7/1.
//

import SwiftUI

struct PlaybackWidget: View {
    var body: some View {
        Image(systemName: "play.fill")
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
    }
}

struct PlaybackWidget_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackWidget()
    }
}
