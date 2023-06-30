//
//  GestureWidget.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/26.
//

import SwiftUI
import Combine

public class GestureService : Service {
    
    @ViewState public private(set) var enabled = true
    
    public func configure(_ onOrOff: Bool) {
        self.enabled = onOrOff
    }
    
    public enum Gesture: Equatable {

        public enum Location: Equatable {
            case all, left, right
            
            public static func == (a: Location, b: Location) -> Bool {
                switch (a, b) {
                case (.all, _), (_, .all): return true
                case (.left, .right), (.right, .left): return false
                default: return true
                }
            }
        }

        public enum Direction: Equatable {
            case horizontal, vertical(Location)
        }

        case tap(Location)
        case doubleTap(Location)
        case drag(Direction)
        case longPress(Location)
        case rotate
        case pinch
    }
    
    private let observable = PassthroughSubject<GestureEvent, Never>()
    
    public struct GestureEvent {
        
        public enum Action {
            case start, end
        }
        
        public enum Value {
            case tap(CGPoint)
            case doubleTap(CGPoint)
            case drag(DragGesture.Value)
            case longPress(CGPoint)
            case rotate(RotationGesture.Value)
            case pinch(MagnificationGesture.Value)
        }
        
        public let gesture: Gesture
        public let action: Action
        public let value: Value
    }
    
    public func observe(_ gesture: Gesture, handler: @escaping (GestureEvent)->Void) -> AnyCancellable {
        observable.filter { event in
            event.gesture == gesture
        }.sink { event in
            handler(event)
        }
    }
    
    //MARK: Individual Gesture Handler
    
    fileprivate func handleTap(_ value: CGPoint, action: GestureEvent.Action) {
        
        let leftSide = value.x < context[ViewSizeService.self].width * 0.5
        let event = GestureEvent(gesture: .tap( leftSide ? .left : .right ), action: action, value: .tap(value))
        observable.send(event)
    }
    
    fileprivate func handleDoubleTap(_ value: CGPoint, action: GestureEvent.Action) {
        
        let leftSide = value.x < context[ViewSizeService.self].width * 0.5
        let event = GestureEvent(gesture: .doubleTap( leftSide ? .left : .right ), action: action, value: .tap(value))
        observable.send(event)
    }
    
    fileprivate var lastDragGesture: GestureEvent?
    
    fileprivate func handleDrag(_ value: DragGesture.Value, action: GestureEvent.Action) {
        
        let direction: Gesture.Direction = {
            
            if let last = lastDragGesture, case let .drag(direction) = last.gesture {
                return direction
            }
            
            let horizontal = value.translation.width > value.translation.height
            if horizontal {
                return .horizontal
            }
            let leftSide = value.startLocation.x < context[ViewSizeService.self].width * 0.5
            if leftSide {
                return .vertical(.left)
            } else {
                return .vertical(.right)
            }
        }()
        
        let event = GestureEvent(gesture: .drag(direction), action: action, value: .drag(value))
        
        switch action {
        case .start:
            if lastDragGesture == nil {
                lastDragGesture = event
            }
        case .end:
            lastDragGesture = nil
        }
        
        observable.send(event)
    }
    
    fileprivate func handlePinch(_ value: MagnificationGesture.Value, action: GestureEvent.Action) {
        let event = GestureEvent(gesture: .pinch, action: action, value: .pinch(value))
        observable.send(event)
    }
    
    fileprivate func handleRotation(_ value: RotationGesture.Value, action: GestureEvent.Action) {
        let event = GestureEvent(gesture: .rotate, action: action, value: .rotate(value))
        observable.send(event)
    }
}

struct GestureWidget: View {
    var body: some View {
        WithService(GestureService.self) { service in
            if service.enabled {
                Color.clear.contentShape(Rectangle())
                    .onTapGesture(count: 2) { value in
                        service.handleDoubleTap(value, action: .end)
                    }
                    .onTapGesture(count: 1) { value in
                        service.handleTap(value, action: .end)
                    }
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                service.handleDrag(value, action: .start)
                            }
                            .onEnded{ value in
                                service.handleDrag(value, action: .end)
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                service.handlePinch(value, action: .start)
                            }
                            .onEnded { value in
                                service.handlePinch(value, action: .end)
                            }
                    )
                    .gesture(
                        RotationGesture()
                            .onChanged { value in
                                service.handleRotation(value, action: .start)
                            }
                            .onEnded { value in
                                service.handleRotation(value, action: .end)
                            }
                    )
            }
        }
    }
}
