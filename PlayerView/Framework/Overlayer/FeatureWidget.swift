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
        case left(()->AnyView)
        case right(()->AnyView)
    }
    
    @ViewState fileprivate var feature: Feature?
    
    private var cancellables = [AnyCancellable]()
    
    public required init(_ context: Context) {
        super.init(context)
        
        let gestureService = context[GestureService.self]
        gestureService.observeTap { [weak self] in
            self?.dismiss()
        }.store(in: &cancellables)
    }
    
    public func left(_ viewGetter: @escaping ()->AnyView) {
        withAnimation {
            feature = .left(viewGetter)
        }
    }
    
    public func right(_ viewGetter: @escaping ()->AnyView) {
        withAnimation {
            feature = .right(viewGetter)
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
                    if case let .left(view) = service.feature {
                        view()
                            .frame(maxHeight: .infinity)
                            .transition(.move(edge: .leading))
                    }
                }
                
                VStack(alignment: .trailing) {
                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: 0)
                    if case let .right(view) = service.feature {
                        view()
                            .frame(maxHeight: .infinity)
                            .transition(.move(edge: .trailing))
                    }
                }
            }
        }
    }
}

