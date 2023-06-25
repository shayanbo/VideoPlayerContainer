//
//  ControlWidget.swift
//  PlayerView
//
//  Created by shayanbo on 2023/6/15.
//

import SwiftUI
import Combine

fileprivate extension ControlService {
    
    static func horizontal(_ views: [IdentifableView]) -> any View {
        HStack { ForEach(views) { $0 } }
    }
    
    static func vertical(_ views: [IdentifableView]) -> any View {
        VStack { ForEach(views) { $0 } }
    }
    
    static func emptyItems() -> [IdentifableView] {
        return [IdentifableView]()
    }
}

public class ControlService : Service {
    
    private var cancellables = [AnyCancellable]()
    
    @ViewState fileprivate var horizontalSpacing = 10.0
    
    @ViewState fileprivate var shadowForTopBar: LinearGradient? = .init(colors: [.black.opacity(0.15), .black.opacity(0)], startPoint: .top, endPoint: .bottom)
    @ViewState fileprivate var shadowForBottomBar: LinearGradient? = .init(colors: [.black.opacity(0.15), .black.opacity(0)], startPoint: .bottom, endPoint: .top)
    
    fileprivate struct ControlBar {
        var top = ControlService.horizontal
        var left = ControlService.vertical
        var right = ControlService.vertical
        var bottom = ControlService.horizontal
        var center = ControlService.horizontal
    }
    
    @ViewState fileprivate var halfScreenControlBar = ControlBar()
    @ViewState fileprivate var fullScreenControlBar = ControlBar()
    @ViewState fileprivate var portraitScreenControlBar = ControlBar()
    
    fileprivate struct ControlBarItems {
        var top = ControlService.emptyItems
        var left = ControlService.emptyItems
        var right = ControlService.emptyItems
        var bottom = ControlService.emptyItems
        var center = ControlService.emptyItems
    }
    
    @ViewState fileprivate var halfScreenControlBarItems = ControlBarItems()
    @ViewState fileprivate var fullScreenControlBarItems = ControlBarItems()
    @ViewState fileprivate var portraitScreenControlBarItems = ControlBarItems()
    
    fileprivate struct Transition {
        var top = AnyTransition.move(edge: .top)
        var left = AnyTransition.move(edge: .leading)
        var right = AnyTransition.move(edge: .trailing)
        var bottom = AnyTransition.move(edge: .bottom)
        var center = AnyTransition.opacity
    }
    
    @ViewState fileprivate var halfScreenTransition = Transition()
    @ViewState fileprivate var fullScreenTransition = Transition()
    @ViewState fileprivate var portraitScreenTransition = Transition()
    
    public enum ControlStyle {
        case always
        case never
        case auto(DispatchTimeInterval)
        case manual
    }
    
    @ViewState fileprivate var hidden = false
    fileprivate var controlStyle = ControlStyle.auto(.seconds(3))
    
    @StateSync(serviceType: StatusService.self, keyPath: \.$status) fileprivate var status
    
    public required init(_ context: Context) {
        super.init(context)
        
        let service = context[GestureService.self]
        service.observeTap {
            withAnimation {
                let service = context[ControlService.self]
                service.didClick()
            }
        }.store(in: &cancellables)
    }
    
    private func didClick() {
        switch self.controlStyle {
        case .always: break
        case .never: break
        case .manual:
            withAnimation {
                hidden.toggle()
            }
        case let .auto(duration):
            withAnimation {
                hidden.toggle()
            }
            if !hidden {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                    withAnimation {
                        self?.hidden = true
                    }
                }
            }
        }
    }
    
    public func configure(controlStyle: ControlStyle) {
        self.controlStyle = controlStyle
        
        switch controlStyle {
        case .always: hidden = false
        case .never: hidden = true
        case .manual:break
        case .auto: break
        }
    }
    
    public func configure(_ location: Location, transition: AnyTransition) {
        switch location {
        case let .halfScreen(direction):
            switch direction {
            case .top:
                self.halfScreenTransition.top = transition
            case .left:
                self.halfScreenTransition.left = transition
            case .right:
                self.halfScreenTransition.right = transition
            case .bottom:
                self.halfScreenTransition.bottom = transition
            case .center:
                self.halfScreenTransition.center = transition
            }
        case let .fullScreen(direction):
            switch direction {
            case .top:
                self.fullScreenTransition.top = transition
            case .left:
                self.fullScreenTransition.left = transition
            case .right:
                self.fullScreenTransition.right = transition
            case .bottom:
                self.fullScreenTransition.bottom = transition
            case .center:
                self.fullScreenTransition.center = transition
            }
        case let .portrait(direction):
            switch direction {
            case .top:
                self.portraitScreenTransition.top = transition
            case .left:
                self.portraitScreenTransition.left = transition
            case .right:
                self.portraitScreenTransition.right = transition
            case .bottom:
                self.portraitScreenTransition.bottom = transition
            case .center:
                self.portraitScreenTransition.center = transition
            }
        }
    }
    
    public func configure(_ location: Location, layout: @escaping ([IdentifableView]) -> any View) {
        switch location {
        case let .fullScreen(direction):
            switch direction {
            case .left:
                self.fullScreenControlBar.left = layout
            case .top:
                self.fullScreenControlBar.top = layout
            case .right:
                self.fullScreenControlBar.right = layout
            case .bottom:
                self.fullScreenControlBar.bottom = layout
            case .center:
                self.fullScreenControlBar.center = layout
            }
        case let .halfScreen(direction):
            switch direction {
            case .left:
                self.halfScreenControlBar.left = layout
            case .top:
                self.halfScreenControlBar.top = layout
            case .right:
                self.halfScreenControlBar.right = layout
            case .bottom:
                self.halfScreenControlBar.bottom = layout
            case .center:
                self.halfScreenControlBar.center = layout
            }
        case let .portrait(direction):
            switch direction {
            case .left:
                self.portraitScreenControlBar.left = layout
            case .top:
                self.portraitScreenControlBar.top = layout
            case .right:
                self.portraitScreenControlBar.right = layout
            case .bottom:
                self.portraitScreenControlBar.bottom = layout
            case .center:
                self.portraitScreenControlBar.center = layout
            }
        }
    }
    
    public func configure(_ location: Location, itemsGetter: @escaping ()->[IdentifableView]) {
        
        switch location {
        case let .halfScreen(direction):
            switch direction {
            case .top:
                self.halfScreenControlBarItems.top = itemsGetter
            case .left:
                self.halfScreenControlBarItems.left = itemsGetter
            case .right:
                self.halfScreenControlBarItems.right = itemsGetter
            case .bottom:
                self.halfScreenControlBarItems.bottom = itemsGetter
            case .center:
                self.halfScreenControlBarItems.center = itemsGetter
            }
        case let .fullScreen(direction):
            switch direction {
            case .top:
                self.fullScreenControlBarItems.top = itemsGetter
            case .left:
                self.fullScreenControlBarItems.left = itemsGetter
            case .right:
                self.fullScreenControlBarItems.right = itemsGetter
            case .bottom:
                self.fullScreenControlBarItems.bottom = itemsGetter
            case .center:
                self.fullScreenControlBarItems.center = itemsGetter
            }
        case let .portrait(direction):
            switch direction {
            case .top:
                self.portraitScreenControlBarItems.top = itemsGetter
            case .left:
                self.portraitScreenControlBarItems.left = itemsGetter
            case .right:
                self.portraitScreenControlBarItems.right = itemsGetter
            case .bottom:
                self.portraitScreenControlBarItems.bottom = itemsGetter
            case .center:
                self.portraitScreenControlBarItems.center = itemsGetter
            }
        }
    }
    
    public func configure(shadow: Shadow) {
        switch shadow {
        case let .top(gradient):
            shadowForTopBar = gradient
        case let .bottom(gradient):
            shadowForBottomBar = gradient
        }
    }
    
    public func configure(spacing: CGFloat) {
        horizontalSpacing = spacing
    }
}

public extension ControlService {
    
    enum Location {
        
        public enum Direction {
            case top
            case left
            case right
            case bottom
            case center
        }
        
        case fullScreen(Direction)
        case halfScreen(Direction)
        case portrait(Direction)
    }
    
    enum Shadow {
        case top(LinearGradient?)
        case bottom(LinearGradient?)
    }
}

struct ControlWidget: View {
    
    @ViewBuilder var top: some View {
        WithService(ControlService.self) { service in
            if !service.hidden {
                
                Group {
                    switch service.status {
                    case .halfScreen:
                        AnyView( service.halfScreenControlBar.top(service.halfScreenControlBarItems.top()) )
                    case .fullScreen:
                        AnyView( service.fullScreenControlBar.top(service.fullScreenControlBarItems.top()) )
                    case .portrait:
                        AnyView( service.portraitScreenControlBar.top(service.portraitScreenControlBarItems.top()) )
                    }
                }
                .padding([.leading, .trailing], service.horizontalSpacing)
                .frame(maxWidth: .infinity)
                .background(service.shadowForTopBar)
                .transition({
                    switch service.status {
                    case .halfScreen:
                        return service.halfScreenTransition.top
                    case .fullScreen:
                        return service.fullScreenTransition.top
                    case .portrait:
                        return service.portraitScreenTransition.top
                    }
                }())
            }
        }
    }
    
    @ViewBuilder var sides: some View {
        WithService(ControlService.self) { service in
            HStack {
                
                if !service.hidden {
                    Group {
                        switch service.status {
                        case .halfScreen:
                            AnyView( service.halfScreenControlBar.left(service.halfScreenControlBarItems.left()) )
                        case .fullScreen:
                            AnyView( service.fullScreenControlBar.left(service.fullScreenControlBarItems.left()) )
                        case .portrait:
                            AnyView( service.portraitScreenControlBar.left(service.portraitScreenControlBarItems.left()) )
                        }
                    }
                    .transition({
                        switch service.status {
                        case .halfScreen:
                            return service.halfScreenTransition.left
                        case .fullScreen:
                            return service.fullScreenTransition.left
                        case .portrait:
                            return service.portraitScreenTransition.left
                        }
                    }())
                }
                
                Spacer()
                
                if !service.hidden {
                    Group {
                        switch service.status {
                        case .halfScreen:
                            AnyView( service.halfScreenControlBar.center(service.halfScreenControlBarItems.center()) )
                        case .fullScreen:
                            AnyView( service.fullScreenControlBar.center(service.fullScreenControlBarItems.center()) )
                        case .portrait:
                            AnyView( service.portraitScreenControlBar.center(service.portraitScreenControlBarItems.center()) )
                        }
                    }
                    .transition({
                        switch service.status {
                        case .halfScreen:
                            return service.halfScreenTransition.center
                        case .fullScreen:
                            return service.fullScreenTransition.center
                        case .portrait:
                            return service.portraitScreenTransition.center
                        }
                    }())
                }
                
                Spacer()
                
                if !service.hidden {
                    Group {
                        switch service.status {
                        case .halfScreen:
                            AnyView( service.halfScreenControlBar.right(service.halfScreenControlBarItems.right()) )
                        case .fullScreen:
                            AnyView( service.fullScreenControlBar.right(service.fullScreenControlBarItems.right()) )
                        case .portrait:
                            AnyView( service.portraitScreenControlBar.right(service.portraitScreenControlBarItems.right()) )
                        }
                    }
                    .transition({
                        switch service.status {
                        case .halfScreen:
                            return service.halfScreenTransition.right
                        case .fullScreen:
                            return service.fullScreenTransition.right
                        case .portrait:
                            return service.portraitScreenTransition.right
                        }
                    }())
                }
            }
            .padding([.leading, .trailing], service.horizontalSpacing)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder var bottom: some View {
        WithService(ControlService.self) { service in
            if !service.hidden {
                
                Group {
                    switch service.status {
                    case .halfScreen:
                        AnyView( service.halfScreenControlBar.bottom(service.halfScreenControlBarItems.bottom()) )
                    case .fullScreen:
                        AnyView( service.fullScreenControlBar.bottom(service.fullScreenControlBarItems.bottom()) )
                    case .portrait:
                        AnyView( service.portraitScreenControlBar.bottom(service.portraitScreenControlBarItems.bottom()) )
                    }
                }
                .padding([.leading, .trailing], service.horizontalSpacing)
                .background {service.shadowForBottomBar }
                .frame(maxWidth: .infinity)
                .transition({
                    switch service.status {
                    case .halfScreen:
                        return service.halfScreenTransition.bottom
                    case .fullScreen:
                        return service.fullScreenTransition.bottom
                    case .portrait:
                        return service.portraitScreenTransition.bottom
                    }
                }())
            }
        }
    }
    
    var body: some View {
        VStack {
            top
            sides
            bottom
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}

public struct IdentifableView : View, Identifiable {
    
    public let id: String
    @ViewBuilder let content: ()->any View
    
    public var body: some View {
        AnyView(self.content())
    }
}
