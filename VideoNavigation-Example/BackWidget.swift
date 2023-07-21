//
//  BackWidget.swift
//  VideoNavigation-Example
//
//  Created by shayanbo on 2023/7/21.
//

import SwiftUI

struct BackWidget: View {
    
    @Environment(\.dismiss) fileprivate var dismiss
    
    var body: some View {
        Image(systemName: "chevron.backward")
            .frame(width: 25, height: 35)
            .contentShape(Rectangle())
            .foregroundColor(.white)
            .onTapGesture {
                dismiss()
            }
    }
}
