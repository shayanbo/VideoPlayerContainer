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
        var viewGetter: ()->AnyView
    }
    
    @ViewState private(set) var feature: Feature?
    
    private var cancellables = [AnyCancellable]()
    
    public required init(_ context: Context) {
        super.init(context)
        
        let gestureService = context[GestureService.self]
        gestureService.observeTap { [weak self] in
            self?.dismiss()
        }.store(in: &cancellables)
    }
    
    public enum Direction: Equatable {
        
        public enum Style: Equatable {
            case cover
            case squeeze
        }
        
        case left(Style)
        case right(Style)
    }
    
    public func present(_ direction: Direction, viewGetter: @escaping ()-> AnyView) {
        withAnimation {
            feature = Feature(direction: direction, viewGetter: viewGetter)
        }
    }
    
    public func dismiss() {
        withAnimation {
            feature = nil
        }
    }
}

struct FeatureWidget: View {
    
    var body: some View {
        
        WithService(FeatureService.self) { service in
            ZStack {
                
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: 0)
                    if let feature = service.feature, feature.direction == .left(.cover) {
                        AnyView(
                            feature.viewGetter()
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
                            feature.viewGetter()
                                .frame(maxHeight: .infinity)
                                .transition(.move(edge: .trailing))
                        )
                    }
                }
            }
        }
    }
}

