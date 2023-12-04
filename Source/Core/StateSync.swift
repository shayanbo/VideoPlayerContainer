//
//  StateSync.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/22.
//

import Foundation
import Combine

private let lock = NSRecursiveLock()

/// StateSync is bit like ``ViewState``, it's used to update its enclosing Widget. but the state being modified is from other service.
///
/// For example, when you are coding a ``Widget`` that need to update when the status changes, like from 'Halfscreen' to 'Fullscreen'
/// ```swift
/// class DemoService : Service {
///     @StateSync(serviceType: StatusService.self, keyPath: \.$status) fileprivate var status
/// }
///
/// struct DemoWidget : Widget {
///     var body: some View {
///         WithService(DemoService.self) { service in
///             if service.status == .fullScreen {
///                 Text("state: fullscreen")
///             } else {
///                 Text("state: halfscreen")
///             }
///         }
///     }
/// }
/// ```
/// This way, when the status changes, the DemoWidget will update itself, showing corresponding View as needed.
///
@propertyWrapper
public class StateSync<S, Value> where S: Service {
    
    private var initialized = false
    private var cancellables = [AnyCancellable]()
    
    public var wrappedValue: Value {
        fatalError()
    }
    
    private let serviceType: S.Type
    private let keyPath: KeyPath<S, CurrentValueSubject<Value, Never>>
    
    public init(serviceType: S.Type, keyPath: KeyPath<S, CurrentValueSubject<Value, Never>>) {
        self.serviceType = serviceType
        self.keyPath = keyPath
    }
    
    public static subscript<OuterSelf: Service>(_enclosingInstance observed: OuterSelf, wrapped wrappedKeyPath: KeyPath<OuterSelf, Value>, storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, StateSync>) -> Value? {
        
        let sync = observed[keyPath: storageKeyPath]
        
        lock.lock()
        defer {
            sync.initialized = true
            lock.unlock()
        }
        
        if !sync.initialized {
            
            let published = observed.context?[sync.serviceType][keyPath: sync.keyPath]
            published?.dropFirst().sink { x in
                observed.objectWillChange.send()
            }.store(in: &sync.cancellables)
        }
        return observed.context?[sync.serviceType][keyPath: sync.keyPath].value
    }
}
