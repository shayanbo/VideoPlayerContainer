//
//  ControlWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/15.
//

import SwiftUI
import Combine

public class ControlService : Service {
    
    private var cancellables = [AnyCancellable]()
    
    @ViewState fileprivate var halfScreenInsets = EdgeInsets()
    @ViewState fileprivate var fullScreenInsets = EdgeInsets()
    @ViewState fileprivate var portraitScreenInsets = EdgeInsets()
    
    fileprivate struct ControlBar {
        
        static func horizontal(_ views: [IdentifableView]) -> any View {
            HStack { ForEach(views) { $0 } }
        }
        static func leftVertical(_ views: [IdentifableView]) -> any View {
            VStack(alignment: .leading) { ForEach(views) { $0 } }
        }
        static func rightVertical(_ views: [IdentifableView]) -> any View {
            VStack(alignment: .trailing) { ForEach(views) { $0 } }
        }
        
        var top1 = horizontal
        var top2 = horizontal
        var left = leftVertical
        var right = rightVertical
        var bottom1 = horizontal
        var bottom2 = horizontal
        var bottom3 = horizontal
        var center = horizontal
    }
    
    @ViewState fileprivate var halfScreenControlBar = ControlBar()
    @ViewState fileprivate var fullScreenControlBar = ControlBar()
    @ViewState fileprivate var portraitScreenControlBar = ControlBar()
    
    fileprivate struct ControlBarItems {
        var top1 = [IdentifableView]()
        var top2 = [IdentifableView]()
        var left = [IdentifableView]()
        var right = [IdentifableView]()
        var bottom1 = [IdentifableView]()
        var bottom2 = [IdentifableView]()
        var bottom3 = [IdentifableView]()
        var center = [IdentifableView]()
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
    
    fileprivate struct Shadow {
        var top: AnyView? = AnyView(LinearGradient(colors: [.black.opacity(0.15), .black.opacity(0)], startPoint: .top, endPoint: .bottom))
        var left: AnyView? = nil
        var right: AnyView? = nil
        var bottom: AnyView? = AnyView(LinearGradient(colors: [.black.opacity(0.15), .black.opacity(0)], startPoint: .bottom, endPoint: .top))
        var center: AnyView? = nil
    }
    
    @ViewState fileprivate var shadow: AnyView?
    
    @ViewState fileprivate var halfScreenShadow = Shadow()
    @ViewState fileprivate var fullScreenShadow = Shadow()
    @ViewState fileprivate var portraitScreenShadow = Shadow()
    
    public enum DisplayStyle {
        case always
        case never
        case auto(firstAppear: Bool, animation: Animation?, duration: TimeInterval)
        case manual(firstAppear: Bool, animation: Animation?)
        case custom(animation: Animation?)
    }
    
    @ViewState fileprivate var hidden = true
    private var autoHiddenTimer: Timer?
    
    fileprivate var displayStyle = DisplayStyle.auto(firstAppear: false, animation: .default, duration: 5)
    
    @StateSync(serviceType: StatusService.self, keyPath: \.$status) fileprivate var status
    
    public required init(_ context: Context) {
        super.init(context)
        
        let service = context[GestureService.self]
        service.observe(.tap(.all)) { _ in
            withAnimation {
                let service = context[ControlService.self]
                service.handleTap()
            }
        }.store(in: &cancellables)
    }
    
    private func handleTap() {
        switch displayStyle {
        case let .manual(firstAppear: _, animation: animation):
            withAnimation(animation) {
                self.hidden.toggle()
            }
        case let .auto(firstAppear: _, animation: animation, duration: duration):
            
            autoHiddenTimer?.invalidate()
            
            withAnimation(animation) {
                self.hidden.toggle()
            }
            if !hidden {
                autoHiddenTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { [weak self] timer in
                    withAnimation {
                        self?.hidden.toggle()
                    }
                })
            }
        default: break
        }
    }
    
    public func present() {
        
        guard !isPresented else {
            return
        }
        
        handleTap()
        
        if case let .custom(animation: animation) = displayStyle {
            withAnimation(animation) {
                self.hidden = false
            }
        }
    }
    
    public func dismiss() {
        
        guard isPresented else {
            return
        }
        
        handleTap()
        
        if case let .custom(animation: animation) = displayStyle {
            withAnimation(animation) {
                self.hidden = true
            }
        }
    }
    
    public var isPresented: Bool {
        !hidden
    }
    
    public func configure(displayStyle: DisplayStyle) {
        self.displayStyle = displayStyle
        
        switch displayStyle {
        case .always: hidden = false
        case .never: hidden = true
        case .manual(let firstAppear, _): hidden = !firstAppear
        case .auto(let firstAppear, _, _): hidden = !firstAppear
        case .custom: break
        }
    }
    
    public func configure(_ status: ScreenStatus, insets: EdgeInsets) {
        switch status {
        case .halfScreen:
            halfScreenInsets = insets
        case .fullScreen:
            fullScreenInsets = insets
        case .portrait:
            portraitScreenInsets = insets
        }
    }
    
    public func configure(_ location: RawLocation, transition: AnyTransition) {
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
            case .top1:
                self.fullScreenControlBar.top1 = layout
            case .top2:
                self.fullScreenControlBar.top2 = layout
            case .right:
                self.fullScreenControlBar.right = layout
            case .bottom1:
                self.fullScreenControlBar.bottom1 = layout
            case .bottom2:
                self.fullScreenControlBar.bottom2 = layout
            case .bottom3:
                self.fullScreenControlBar.bottom3 = layout
            case .center:
                self.fullScreenControlBar.center = layout
            }
        case let .halfScreen(direction):
            switch direction {
            case .left:
                self.halfScreenControlBar.left = layout
            case .top1:
                self.halfScreenControlBar.top1 = layout
            case .top2:
                self.halfScreenControlBar.top2 = layout
            case .right:
                self.halfScreenControlBar.right = layout
            case .bottom1:
                self.halfScreenControlBar.bottom1 = layout
            case .bottom2:
                self.halfScreenControlBar.bottom2 = layout
            case .bottom3:
                self.halfScreenControlBar.bottom3 = layout
            case .center:
                self.halfScreenControlBar.center = layout
            }
        case let .portrait(direction):
            switch direction {
            case .left:
                self.portraitScreenControlBar.left = layout
            case .top1:
                self.portraitScreenControlBar.top1 = layout
            case .top2:
                self.portraitScreenControlBar.top2 = layout
            case .right:
                self.portraitScreenControlBar.right = layout
            case .bottom1:
                self.portraitScreenControlBar.bottom1 = layout
            case .bottom2:
                self.portraitScreenControlBar.bottom2 = layout
            case .bottom3:
                self.portraitScreenControlBar.bottom3 = layout
            case .center:
                self.portraitScreenControlBar.center = layout
            }
        }
    }
    
    public func configure(_ location: Location, content: @escaping ()->[any View]) {
        
        let items = content().map { view in
            IdentifableView(id: UUID().uuidString) { view }
        }
        
        switch location {
        case let .halfScreen(direction):
            switch direction {
            case .top1:
                self.halfScreenControlBarItems.top1 = items
            case .top2:
                self.halfScreenControlBarItems.top2 = items
            case .left:
                self.halfScreenControlBarItems.left = items
            case .right:
                self.halfScreenControlBarItems.right = items
            case .bottom1:
                self.halfScreenControlBarItems.bottom1 = items
            case .bottom2:
                self.halfScreenControlBarItems.bottom2 = items
            case .bottom3:
                self.halfScreenControlBarItems.bottom3 = items
            case .center:
                self.halfScreenControlBarItems.center = items
            }
        case let .fullScreen(direction):
            switch direction {
            case .top1:
                self.fullScreenControlBarItems.top1 = items
            case .top2:
                self.fullScreenControlBarItems.top2 = items
            case .left:
                self.fullScreenControlBarItems.left = items
            case .right:
                self.fullScreenControlBarItems.right = items
            case .bottom1:
                self.fullScreenControlBarItems.bottom1 = items
            case .bottom2:
                self.fullScreenControlBarItems.bottom2 = items
            case .bottom3:
                self.fullScreenControlBarItems.bottom3 = items
            case .center:
                self.fullScreenControlBarItems.center = items
            }
        case let .portrait(direction):
            switch direction {
            case .top1:
                self.portraitScreenControlBarItems.top1 = items
            case .top2:
                self.portraitScreenControlBarItems.top2 = items
            case .left:
                self.portraitScreenControlBarItems.left = items
            case .right:
                self.portraitScreenControlBarItems.right = items
            case .bottom1:
                self.portraitScreenControlBarItems.bottom1 = items
            case .bottom2:
                self.portraitScreenControlBarItems.bottom2 = items
            case .bottom3:
                self.portraitScreenControlBarItems.bottom3 = items
            case .center:
                self.portraitScreenControlBarItems.center = items
            }
        }
    }
    
    public func configure(shadow: AnyView?) {
        self.shadow = shadow
    }
    
    public func configure(_ location: RawLocation, shadow: AnyView?) {
        switch location {
        case let .halfScreen(direction):
            switch direction {
            case .top:
                self.halfScreenShadow.top = shadow
            case .left:
                self.halfScreenShadow.left = shadow
            case .right:
                self.halfScreenShadow.right = shadow
            case .bottom:
                self.halfScreenShadow.bottom = shadow
            case .center:
                self.halfScreenShadow.center = shadow
            }
        case let .fullScreen(direction):
            switch direction {
            case .top:
                self.fullScreenShadow.top = shadow
            case .left:
                self.fullScreenShadow.left = shadow
            case .right:
                self.fullScreenShadow.right = shadow
            case .bottom:
                self.fullScreenShadow.bottom = shadow
            case .center:
                self.fullScreenShadow.center = shadow
            }
        case let .portrait(direction):
            switch direction {
            case .top:
                self.portraitScreenShadow.top = shadow
            case .left:
                self.portraitScreenShadow.left = shadow
            case .right:
                self.portraitScreenShadow.right = shadow
            case .bottom:
                self.portraitScreenShadow.bottom = shadow
            case .center:
                self.portraitScreenShadow.center = shadow
            }
        }
    }
}

public extension ControlService {
    
    enum RawDirection {
        case top, left, right, bottom, center
    }
    
    enum ScreenStatus {
        case halfScreen, fullScreen, portrait
    }
    
    enum Direction {
        case top1, top2, left, right, bottom1, bottom2, bottom3, center
    }
    
    enum RawLocation {
        case fullScreen(RawDirection)
        case halfScreen(RawDirection)
        case portrait(RawDirection)
    }
    
    enum Location {
        case fullScreen(Direction)
        case halfScreen(Direction)
        case portrait(Direction)
    }
}

struct ControlWidget: View {
    
    @ViewBuilder var top: some View {
        WithService(ControlService.self) { service in
            if !service.hidden {
                
                VStack {
                    switch service.status {
                    case .halfScreen:
                        AnyView( service.halfScreenControlBar.top1(service.halfScreenControlBarItems.top1) )
                    case .fullScreen:
                        AnyView( service.fullScreenControlBar.top1(service.fullScreenControlBarItems.top1) )
                    case .portrait:
                        AnyView( service.portraitScreenControlBar.top1(service.portraitScreenControlBarItems.top1) )
                    }
                    
                    switch service.status {
                    case .halfScreen:
                        AnyView( service.halfScreenControlBar.top2(service.halfScreenControlBarItems.top2) )
                    case .fullScreen:
                        AnyView( service.fullScreenControlBar.top2(service.fullScreenControlBarItems.top2) )
                    case .portrait:
                        AnyView( service.portraitScreenControlBar.top2(service.portraitScreenControlBarItems.top2) )
                    }
                }
                .padding(.leading, {
                    switch service.status {
                    case .halfScreen:
                        return service.halfScreenInsets.leading
                    case .fullScreen:
                        return service.fullScreenInsets.leading
                    case .portrait:
                        return service.portraitScreenInsets.leading
                    }
                }())
                .padding(.trailing, {
                    switch service.status {
                    case .halfScreen:
                        return service.halfScreenInsets.trailing
                    case .fullScreen:
                        return service.fullScreenInsets.trailing
                    case .portrait:
                        return service.portraitScreenInsets.trailing
                    }
                }())
                .padding(.top, {
                    switch service.status {
                    case .halfScreen:
                        return service.halfScreenInsets.top
                    case .fullScreen:
                        return service.fullScreenInsets.top
                    case .portrait:
                        return service.portraitScreenInsets.top
                    }
                }())
                .frame(maxWidth: .infinity)
                .background({ () -> AnyView? in 
                    switch service.status {
                    case .halfScreen:
                        return service.halfScreenShadow.top
                    case .fullScreen:
                        return service.fullScreenShadow.top
                    case .portrait:
                        return service.portraitScreenShadow.top
                    }
                }())
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
            HStack(spacing:0) {
                
                if !service.hidden {
                    Group {
                        switch service.status {
                        case .halfScreen:
                            AnyView( service.halfScreenControlBar.left(service.halfScreenControlBarItems.left) )
                        case .fullScreen:
                            AnyView( service.fullScreenControlBar.left(service.fullScreenControlBarItems.left) )
                        case .portrait:
                            AnyView( service.portraitScreenControlBar.left(service.portraitScreenControlBarItems.left) )
                        }
                    }
                    .padding(.leading, {
                        switch service.status {
                        case .halfScreen:
                            return service.halfScreenInsets.leading
                        case .fullScreen:
                            return service.fullScreenInsets.leading
                        case .portrait:
                            return service.portraitScreenInsets.leading
                        }
                    }())
                    .background({ () -> AnyView? in
                        switch service.status {
                        case .halfScreen:
                            return service.halfScreenShadow.left
                        case .fullScreen:
                            return service.fullScreenShadow.left
                        case .portrait:
                            return service.portraitScreenShadow.left
                        }
                    }())
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
                
                Spacer(minLength: 0)
                
                if !service.hidden {
                    Group {
                        switch service.status {
                        case .halfScreen:
                            AnyView( service.halfScreenControlBar.center(service.halfScreenControlBarItems.center) )
                        case .fullScreen:
                            AnyView( service.fullScreenControlBar.center(service.fullScreenControlBarItems.center) )
                        case .portrait:
                            AnyView( service.portraitScreenControlBar.center(service.portraitScreenControlBarItems.center) )
                        }
                    }
                    .background({ () -> AnyView? in
                        switch service.status {
                        case .halfScreen:
                            return service.halfScreenShadow.center
                        case .fullScreen:
                            return service.fullScreenShadow.center
                        case .portrait:
                            return service.portraitScreenShadow.center
                        }
                    }())
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
                
                Spacer(minLength: 0)
                
                if !service.hidden {
                    Group {
                        switch service.status {
                        case .halfScreen:
                            AnyView( service.halfScreenControlBar.right(service.halfScreenControlBarItems.right) )
                        case .fullScreen:
                            AnyView( service.fullScreenControlBar.right(service.fullScreenControlBarItems.right) )
                        case .portrait:
                            AnyView( service.portraitScreenControlBar.right(service.portraitScreenControlBarItems.right) )
                        }
                    }
                    .padding(.trailing, {
                        switch service.status {
                        case .halfScreen:
                            return service.halfScreenInsets.trailing
                        case .fullScreen:
                            return service.fullScreenInsets.trailing
                        case .portrait:
                            return service.portraitScreenInsets.trailing
                        }
                    }())
                    .background({ () -> AnyView? in
                        switch service.status {
                        case .halfScreen:
                            return service.halfScreenShadow.right
                        case .fullScreen:
                            return service.fullScreenShadow.right
                        case .portrait:
                            return service.portraitScreenShadow.right
                        }
                    }())
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder var bottom: some View {
        WithService(ControlService.self) { service in
            if !service.hidden {
                
                VStack {
                    switch service.status {
                    case .halfScreen:
                        AnyView( service.halfScreenControlBar.bottom3(service.halfScreenControlBarItems.bottom3) )
                    case .fullScreen:
                        AnyView( service.fullScreenControlBar.bottom3(service.fullScreenControlBarItems.bottom3) )
                    case .portrait:
                        AnyView( service.portraitScreenControlBar.bottom3(service.portraitScreenControlBarItems.bottom3) )
                    }
                    
                    switch service.status {
                    case .halfScreen:
                        AnyView( service.halfScreenControlBar.bottom2(service.halfScreenControlBarItems.bottom2) )
                    case .fullScreen:
                        AnyView( service.fullScreenControlBar.bottom2(service.fullScreenControlBarItems.bottom2) )
                    case .portrait:
                        AnyView( service.portraitScreenControlBar.bottom2(service.portraitScreenControlBarItems.bottom2) )
                    }
                    
                    switch service.status {
                    case .halfScreen:
                        AnyView( service.halfScreenControlBar.bottom1(service.halfScreenControlBarItems.bottom1) )
                    case .fullScreen:
                        AnyView( service.fullScreenControlBar.bottom1(service.fullScreenControlBarItems.bottom1) )
                    case .portrait:
                        AnyView( service.portraitScreenControlBar.bottom1(service.portraitScreenControlBarItems.bottom1) )
                    }
                }
                .padding(.leading, {
                    switch service.status {
                    case .halfScreen:
                        return service.halfScreenInsets.leading
                    case .fullScreen:
                        return service.fullScreenInsets.leading
                    case .portrait:
                        return service.portraitScreenInsets.leading
                    }
                }())
                .padding(.trailing, {
                    switch service.status {
                    case .halfScreen:
                        return service.halfScreenInsets.trailing
                    case .fullScreen:
                        return service.fullScreenInsets.trailing
                    case .portrait:
                        return service.portraitScreenInsets.trailing
                    }
                }())
                .padding(.bottom, {
                    switch service.status {
                    case .halfScreen:
                        return service.halfScreenInsets.bottom
                    case .fullScreen:
                        return service.fullScreenInsets.bottom
                    case .portrait:
                        return service.portraitScreenInsets.bottom
                    }
                }())
                .background({ () -> AnyView? in
                    switch service.status {
                    case .halfScreen:
                        return service.halfScreenShadow.bottom
                    case .fullScreen:
                        return service.fullScreenShadow.bottom
                    case .portrait:
                        return service.portraitScreenShadow.bottom
                    }
                }())
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
        WithService(ControlService.self) { service in
            ZStack {
                
                if let shadow = service.shadow, !service.hidden {
                    shadow
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.opacity)
                }
                
                VStack(spacing:0) {
                    top
                    sides
                    bottom
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

public struct IdentifableView : View, Identifiable {
    
    public let id: String
    @ViewBuilder let content: ()->any View
    
    public init(id: String, content: @escaping () -> any View) {
        self.id = id
        self.content = content
    }
    
    public var body: some View {
        AnyView(self.content())
    }
}
