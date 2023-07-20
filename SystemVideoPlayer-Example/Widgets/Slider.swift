//
//  Slider.swift
//  SystemVideoPlayer-Example
//
//  Created by shayanbo on 2023/7/20.
//

import SwiftUI

struct Slider<ThumbContent>: View where ThumbContent : View {
    
    private class SliderObservable : ObservableObject {
        var progress: Float = 0
        var offset: Float = 0
        var sliding = false
    }
    
    @StateObject private var o = SliderObservable()
    
    @State private var thumbWidth: CGFloat = 0.0
    
    @Binding var value: Float
    
    @State var clickable = false
    
    @State var trackTintColor: Color = .gray
    
    @State var thumbTintColor: Color = .white
    
    @State var thumbContent: ThumbContent? = nil
    
    @State var animation: Animation? = nil
    
    @State var onEditingChanged: (Bool)->Void = { _ in }
    
    init(
        value: Binding<Float>,
        clickable: Bool = false,
        trackTintColor: Color = .gray,
        thumbTintColor: Color = .white,
        animation: Animation? = nil,
        onEditingChanged: @escaping (Bool)->Void = { _ in }
    )
    where ThumbContent == Never {
        
        self._value = value
        self.thumbContent = thumbContent
        self.clickable = clickable
        self.trackTintColor = trackTintColor
        self.thumbTintColor = thumbTintColor
        self.onEditingChanged = onEditingChanged
        self.animation = animation
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(trackTintColor)
                    .frame(height:5)
                    .cornerRadius(2.5)
                    .padding(.horizontal, thumbWidth * 0.5)
                Rectangle()
                    .fill(thumbTintColor)
                    .frame(width: (proxy.size.width - thumbWidth) * CGFloat(value), height:5)
                    .cornerRadius(2.5)
                    .padding(.horizontal, thumbWidth * 0.5)
                thumbContent?
                    .offset(CGSize(width: (proxy.size.width - thumbWidth) * CGFloat(value), height: 0))
                    .background(
                        GeometryReader { proxy in
                            Color.clear.onAppear {
                                thumbWidth = proxy.size.width
                            }
                        }
                    )
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        o.offset = Float(value.translation.width / (proxy.size.width - thumbWidth))
                        withAnimation(animation) {
                            self.value = min(max(o.progress + o.offset, 0.0), 1.0)
                        }
                        
                        if !o.sliding {
                            o.sliding = true
                            onEditingChanged(true)
                        }
                    }
                    .onEnded { value in
                        o.progress += o.offset
                        o.offset = 0
                        
                        if o.sliding {
                            o.sliding = false
                            onEditingChanged(false)
                        }
                    }
            )
            .onTapGesture { location in
                if clickable {
                    o.progress = Float(location.x / (proxy.size.width - thumbWidth))
                    withAnimation(animation) {
                        value = Float(location.x / (proxy.size.width - thumbWidth))
                    }
                }
            }
        }
    }
}
