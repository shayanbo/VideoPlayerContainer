//
//  StateSync.swift
//  PlayerView
//
//  Created by shayanbo on 2023/6/22.
//

import Foundation
import Combine

private let lock = NSRecursiveLock()

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
    
    public static subscript<OuterSelf: Service>(_enclosingInstance observed: OuterSelf, wrapped wrappedKeyPath: KeyPath<OuterSelf, Value>, storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, StateSync>) -> Value {
        
        let sync = observed[keyPath: storageKeyPath]
        
        lock.lock()
        defer {
            sync.initialized = true
            lock.unlock()
        }
        
        if !sync.initialized {
            
            let published = observed.context[sync.serviceType][keyPath: sync.keyPath]
            published.dropFirst().sink { x in
                observed.objectWillChange.send()
            }.store(in: &sync.cancellables)
        }
        return observed.context[sync.serviceType][keyPath: sync.keyPath].value
    }
}
