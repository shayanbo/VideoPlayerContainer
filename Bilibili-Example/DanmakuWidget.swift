//
//  DanmakuWidget.swift
//  Bilibili-Example
//
//  Created by shayanbo on 2023/7/2.
//

import SwiftUI

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
