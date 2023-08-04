//
//  StatelessWidgets.swift
//  QuickTime-Example
//
//  Created by shayanbo on 2023/7/17.
//

import SwiftUI

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
