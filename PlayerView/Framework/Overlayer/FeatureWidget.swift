//
//  FeatureWidget.swift
//  PlayerView
//
//  Created by shayanbo on 2023/6/15.
//

import SwiftUI
import Combine

public class FeatureService : Service {
    
    enum Feature {
        case left(()->any View)
        case right(()->any View)
    }
    
    @ViewState private(set) var feature: Feature?
    
    public enum Style {
        case cover
        case squeeze
    }
    
    @ViewState private(set) var style: Style = .cover
    
    private var cancellables = [AnyCancellable]()
    
    public required init(_ context: Context) {
        super.init(context)
        
        let gestureService = context[GestureService.self]
        gestureService.observeTap { [weak self] in
            self?.dismiss()
        }.store(in: &cancellables)
    }
    
    public enum Direction {
        case left
        case right
    }
    
    public func present(_ direction: Direction, viewGetter: @escaping ()-> some View) {
        withAnimation {
            switch direction {
            case .left:
                feature = .left(viewGetter)
            case .right:
                feature = .right(viewGetter)
            }
        }
    }
    
    public func dismiss() {
        withAnimation {
            feature = nil
        }
    }
    
    public func configure(style: Style) {
        self.style = style
    }
}

struct FeatureWidget: View {
    
    var body: some View {
        
        WithService(FeatureService.self) { service in
            ZStack {
                if service.style == .cover {
                    
                    VStack(alignment: .leading) {
                        Spacer()
                            .frame(maxWidth: .infinity, maxHeight: 0)
                        if case let .left(view) = service.feature {
                            AnyView(
                                view()
                                    .frame(maxHeight: .infinity)
                                    .transition(.move(edge: .leading))
                            )
                        }
                    }
                    
                    VStack(alignment: .trailing) {
                        Spacer()
                            .frame(maxWidth: .infinity, maxHeight: 0)
                        if case let .right(view) = service.feature {
                            AnyView(
                                view()
                                    .frame(maxHeight: .infinity)
                                    .transition(.move(edge: .trailing))
                            )
                        }
                    }
                }
            }
        }
    }
}

