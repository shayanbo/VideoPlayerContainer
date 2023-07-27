//
//  StatelessWidgets.swift
//  QuickTime-Example
//
//  Created by shayanbo on 2023/7/17.
//

import SwiftUI

struct PiPWidget: View {
    var body: some View {
        Image(systemName: "pip.enter")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundColor(.white)
            .opacity(0.7)
    }
}

struct ShareWidget: View {
    var body: some View {
        Image(systemName: "square.and.arrow.up")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundColor(.white)
            .opacity(0.7)
    }
}

struct MoreWidget: View {
    var body: some View {
        Image(systemName: "chevron.right.2")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundColor(.white)
            .opacity(0.7)
    }
}
