//
//  FeatureWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/15.
//

import SwiftUI
import Combine

/// Service used by FeatureWidget.
///
/// FeatureService is used to pop up panels from 4 directions in the FeatureWidget.
/// 
public class FeatureService : Service {
    
    struct Feature {
        let direction: Direction
        let content: ()->AnyView
        let action: Action
        
        struct Action {
            var beforePresent: ( ()->Void )?
            var afterPresent: ( ()->Void )?
            var beforeDismiss: ( ()->Void )?
            var afterDismiss: ( ()->Void )?
        }
    }
    
    @ViewState private(set) var feature: Feature?
    
    @ViewState fileprivate var dismissOnTap = true
    
    fileprivate var status: StatusService.Status?
    
    required init(_ context: Context) {
        super.init(context)
        context[StatusService.self].$status.sink(receiveValue: { [weak self] status in
            self?.status = status
        }).store(in: &cancellables)
    }
    
    fileprivate var dismissOnStatusChanged = true
    
    private var cancellables = [AnyCancellable]()
    
    public enum Direction: Equatable {
        
        public enum Style: Equatable {
            /// The panel presents over the other views without affecting others.
            case cover
            /// The panel presents with squeezing the space of render view.
            case squeeze(CGFloat)
        }
        
        case left(Style)
        case right(Style)
        case top(Style)
        case bottom(Style)
    }
    
    /// Configure if the tap action will dismiss the panel.
    /// - Parameter dismissOnTap: The boolean value that indicates whether the click will dismiss the panel.
    ///
    public func configure(dismissOnTap: Bool) {
        self.dismissOnTap = dismissOnTap
    }
    
    /// Configure if the status change will dismiss the panel.
    /// - Parameter dismissOnStatusChanged: The boolean value that indicates whether the status change will dismiss the panel.
    ///
    public func configure(dismissOnStatusChanged: Bool) {
        self.dismissOnStatusChanged = dismissOnStatusChanged
    }
    
    /// Present a panel from a direction.
    ///
    /// - Parameters:
    ///     - direction: The panel fly in from this direction.
    ///     - animation: Animation applied on the panel when presenting.
    ///     - beforePresent: The action to perform before the presentation of panel.
    ///     - afterPresent: The action to perform after the presentation of panel.
    ///     - beforeDismiss: The action to perform before the dismissal of panel.
    ///     - afterDismiss: The action to perform after the dismissal of panel.
    ///     - content: View builder that creates the content of panel.
    ///
    public func present(
        _ direction: Direction,
        animation: Animation? = .default,
        beforePresent: ( ()->Void )? = nil,
        afterPresent: ( ()->Void )? = nil,
        beforeDismiss: ( ()->Void )? = nil,
        afterDismiss: ( ()->Void )? = nil,
        content: @escaping ()-> AnyView
    ){  
        let action = Feature.Action(
            beforePresent: beforePresent,
            afterPresent: afterPresent,
            beforeDismiss: beforeDismiss,
            afterDismiss: afterDismiss
        )
        let feature = Feature(direction: direction, content: content, action: action)
        
        feature.action.beforePresent?()
        
        withAnimation(animation) {
            self.feature = feature
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) { [weak self] in
            self?.feature?.action.afterPresent?()
        }
    }
    
    /// Dismiss the presenting panel.
    /// - Parameter animation: Animation applied on the panel when dismissing.
    ///
    public func dismiss(animation: Animation? = .default) {
        let action = feature?.action
        
        action?.beforeDismiss?()
        
        withAnimation(animation) {
            feature = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            action?.afterDismiss?()
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
                            if service.dismissOnTap {
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

public extension Context {
    
    /// Simple alternative for `context[FeatureService.self]`
    var feature: FeatureService {
        self[FeatureService.self]
    }
}
