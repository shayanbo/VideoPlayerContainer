//
//  StepForwardWidget.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/7/1.
//

import SwiftUI

struct StepForwardWidget: View {
    var body: some View {
        Image(systemName: "forward.end.circle")
            .resizable()
            .scaledToFit()
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
    }
}

struct StepForwardWidget_Previews: PreviewProvider {
    static var previews: some View {
        StepForwardWidget()
    }
}
