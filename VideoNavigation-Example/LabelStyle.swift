//
//  LabelStyle.swift
//  VideoNavigation-Example
//
//  Created by shayanbo on 2023/7/21.
//

import SwiftUI

struct ActionStyle : LabelStyle {
    func makeBody(configuration: LabelStyleConfiguration) -> some View {
        HStack {
            configuration.icon
            configuration.title
                .font(.system(size: 13))
        }
    }
}

struct CommentStyle : LabelStyle {
    func makeBody(configuration: LabelStyleConfiguration) -> some View {
        VStack {
            configuration.icon
                .foregroundColor(.gray.opacity(0.7))
            Spacer()
                .frame(height:5)
            configuration.title
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}
