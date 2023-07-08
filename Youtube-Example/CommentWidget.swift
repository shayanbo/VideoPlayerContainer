//
//  CommentWidget.swift
//  Youtube-Example
//
//  Created by shayanbo on 2023/7/2.
//

import SwiftUI
import VideoPlayerContainer

class CommentService: Service {
    
    func closeButtonDidTapped() {
        context[FeatureService.self].dismiss()
    }
}

struct CommentWidget: View {
    var body: some View {
        WithService(CommentService.self) { service in
            NavigationView {
                List {
                    Group {
                        Text("It has been 14 years since Michael Jackson passed away.")
                        Text("I remember when there was tremendous build up to the airing of this video. MTV was clocking down to the day until it aired. Expectations were immense and the video exceeded all of them! It was so very different than videos of that era. Everyone was talking about it. It truly was groundbreaking...and very enjoyable!")
                        Text("Michael was truly an artist . Ahead of his time . Iconic . There will never be another like him")
                        Text("The greatest entertainer in the world, of all time. Please don't ever let his music die.")
                    }
                    .listRowBackground(Color.white)
                    .foregroundColor(.black)
                }
                .background(.white)
                .scrollContentBackground(.hidden)
                
                .navigationTitle("Comments")
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                     ToolbarItemGroup {
                         Image(systemName: "xmark")
                             .onTapGesture {
                                 service.closeButtonDidTapped()
                             }
                     }
                 }
            }
            .padding(.trailing, 60)
            .background(.white)
        }
    }
}
