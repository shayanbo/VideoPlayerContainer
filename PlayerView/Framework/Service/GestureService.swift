//
//  GestureService.swift
//  PlayerView
//
//  Created by shayanbo on 2023/6/18.
//

import Foundation
import Combine
import SwiftUI

public class GestureService : Service {
    
    //MARK: Single Tap
    
    private let tap = PassthroughSubject<Void, Never>()
    
    public func performTap() {
        tap.send(())
    }
    
    public func observeTap(_ handler: @escaping ()->Void) -> AnyCancellable {
        tap.sink { _ in
            handler()
        }
    }
    
    //MARK: Double Tap
    
    private let doubleTap = PassthroughSubject<Void, Never>()
    
    public func performDoubleTap() {
        doubleTap.send(())
    }
    
    public func observeDoubleTap(_ handler: @escaping ()->Void) -> AnyCancellable {
        doubleTap.sink { _ in
            handler()
        }
    }
    
    //MARK: Drag
    
    public enum DragEvent {
        case changed(DragGesture.Value)
        case end(DragGesture.Value)
    }
    
    private let drag = PassthroughSubject<DragEvent, Never>()
    
    public func performDrag(_ event: DragEvent) {
        drag.send(event)
    }
    
    public func observeDrag(_ handler: @escaping (DragEvent)->Void) -> AnyCancellable {
        drag.sink {
            handler($0)
        }
    }
    
    //MARK: Long Press
    
    public enum LongPressEvent {
        case start
        case end
    }
    
    private let longPress = PassthroughSubject<LongPressEvent, Never>()
    
    public func performLongPress(_ event: LongPressEvent) {
        longPress.send(event)
    }
    
    public func observeLongPress(_ handler: @escaping (LongPressEvent)->Void) -> AnyCancellable {
        longPress.sink {
            handler($0)
        }
    }
}
