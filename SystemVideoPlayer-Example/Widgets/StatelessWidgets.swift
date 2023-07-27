//
//  StatelessWidgets.swift
//  QuickTime-Example
//
//  Created by shayanbo on 2023/7/17.
//

import SwiftUI

struct CloseWidget: View {
    var body: some View {
        Image(systemName: "xmark")
            .foregroundColor(.white)
    }
}

struct AirplayWidget: View {
    var body: some View {
        Image(systemName: "airplayvideo")
            .foregroundColor(.white)
    }
}
