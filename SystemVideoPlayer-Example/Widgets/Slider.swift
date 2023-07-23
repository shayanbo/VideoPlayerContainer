//
//  Slider.swift
//  SystemVideoPlayer-Example
//
//  Created by shayanbo on 2023/7/20.
//

import SwiftUI

extension Slider where ThumbContent == Never {
    
    init(value: Binding<Float>, clickable: Bool = false, trackTintColor: Color = .gray, thumbTintColor: Color = .white, animation: Animation? = nil, onEditingChanged: @escaping (Bool)->Void = { _ in }) {
        self._value = value
        self.clickable = clickable
        self.trackTintColor = trackTintColor
        self.thumbTintColor = thumbTintColor
        self.animation = animation
        self.onEditingChanged = onEditingChanged
    }
}

struct Slider<ThumbContent>: View where ThumbContent : View {
    
    private class SliderObservable : ObservableObject {
        var progress: Float = 0
        var offset: Float = 0
        var sliding = false
    }
    
    private let sliderHeight = 5.0
    
    @StateObject private var o = SliderObservable()
    
    @State private var thumbSize: CGSize = .zero
    
    @Binding var value: Float
    
    var clickable = false
    
    var trackTintColor: Color = .gray
    
    var thumbTintColor: Color = .white
    
    var thumbContent: ( ()->ThumbContent )?
    
    var animation: Animation? = nil
    
    var onEditingChanged: (Bool)->Void = { _ in }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(trackTintColor)
                    .frame(height:sliderHeight)
                    .cornerRadius(2.5)
                    .padding(.horizontal, thumbSize.width * 0.5)
                Rectangle()
                    .fill(thumbTintColor)
                    .frame(width: (proxy.size.width - thumbSize.width) * CGFloat(value), height:sliderHeight)
                    .cornerRadius(2.5)
                    .padding(.horizontal, thumbSize.width * 0.5)
                thumbContent?()
                    .offset(CGSize(width: (proxy.size.width - thumbSize.width) * CGFloat(value), height: 0))
                    .background(
                        GeometryReader { proxy in
                            Color.clear.onAppear {
                                thumbSize = proxy.size
                            }
                        }
                    )
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { value in
                        o.offset = Float(value.translation.width / (proxy.size.width - thumbSize.width)).clamp()
                        withAnimation(animation) {
                            self.value = (o.progress + o.offset).clamp()
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
                    o.progress = Float(location.x / (proxy.size.width - thumbSize.width)).clamp()
                    withAnimation(animation) {
                        value = Float(location.x / (proxy.size.width - thumbSize.width)).clamp()
                    }
                }
            }
        }
        .frame(height: max(thumbSize.height, sliderHeight))
    }
}

extension Float {
    func clamp() -> Self {
        min(max(self, 0.0), 1.0)
    }
}
