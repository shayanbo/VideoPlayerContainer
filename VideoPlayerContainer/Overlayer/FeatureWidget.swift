//
//  FeatureWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/15.
//

import SwiftUI
import Combine

public class FeatureService : Service {
    
    struct Feature {
        var direction: Direction
        var content: ()->AnyView
    }
    
    @ViewState private(set) var feature: Feature?
    
    @ViewState fileprivate var dismissOnClick = true
    
    @StateSync(serviceType: StatusService.self, keyPath: \.$status) fileprivate var status
    
    fileprivate var dismissOnStatusChanged = true
    
    private var cancellables = [AnyCancellable]()
    
    public enum Direction: Equatable {
        
        public enum Style: Equatable {
            case cover
            case squeeze(CGFloat)
        }
        
        case left(Style)
        case right(Style)
        case top(Style)
        case bottom(Style)
    }
    
    public func configure(dismissOnClick: Bool) {
        self.dismissOnClick = dismissOnClick
    }
    
    public func configure(dismissOnStatusChanged: Bool) {
        self.dismissOnStatusChanged = dismissOnStatusChanged
    }
    
    public func present(_ direction: Direction, animation: Animation? = .default, content: @escaping ()-> AnyView) {
        withAnimation(animation) {
            feature = Feature(direction: direction, content: content)
        }
    }
    
    public func dismiss(animation: Animation? = .default) {
        withAnimation(animation) {
            feature = nil
        }
    }
}

struct FeatureWidget: View {
    
    var body: some View {
        
        WithService(FeatureService.self) { service in
            ZStack {
                
                if service.feature != nil {
                    Color.clear.contentShape(Rectangle())
                        .onTapGesture {
                            if service.dismissOnClick {
                                service.dismiss()
                            }
                        }
                }
                
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: 0)
                    if let feature = service.feature, feature.direction == .left(.cover) {
                        AnyView(
                            feature.content()
                                .frame(maxHeight: .infinity)
                                .transition(.move(edge: .leading))
                        )
                    }
                }
                
                VStack(alignment: .trailing) {
                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: 0)
                    if let feature = service.feature, feature.direction == .right(.cover) {
                        AnyView(
                            feature.content()
                                .frame(maxHeight: .infinity)
                                .transition(.move(edge: .trailing))
                        )
                    }
                }
                
                VStack {
                    if let feature = service.feature, feature.direction == .top(.cover) {
                        AnyView(
                            feature.content()
                                .frame(maxWidth: .infinity)
                                .transition(.move(edge: .top))
                        )
                    }
                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                VStack {
                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    if let feature = service.feature, feature.direction == .bottom(.cover) {
                        AnyView(
                            feature.content()
                                .frame(maxWidth: .infinity)
                                .transition(.move(edge: .bottom))
                        )
                    }
                }
            }
            .onChange(of: service.status) { _ in
                if service.dismissOnStatusChanged {
                    service.dismiss()
                }
            }
        }
    }
}

