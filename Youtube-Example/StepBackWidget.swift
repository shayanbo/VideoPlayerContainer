//
//  StepBackWidget.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/7/1.
//

import SwiftUI

struct StepBackWidget: View {
    var body: some View {
        Image(systemName: "backward.end.circle")
            .resizable()
            .scaledToFit()
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
    }
}

struct StepBackWidget_Previews: PreviewProvider {
    static var previews: some View {
        StepBackWidget()
    }
}
