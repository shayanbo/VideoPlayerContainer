//
//  Viewservice.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/22.
//

import Foundation
import Combine

@propertyWrapper
public struct ViewState<Value> {
    
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }
    
    private let publisher: CurrentValueSubject<Value, Never>
    
    public init(wrappedValue: Value) {
        publisher = CurrentValueSubject(wrappedValue)
    }
    
    public var projectedValue: CurrentValueSubject<Value, Never> {
        publisher
    }
    
    public static subscript<OuterSelf: Service>(_enclosingInstance observed: OuterSelf, wrapped wrappedKeyPath: KeyPath<OuterSelf, Value>, storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>) -> Value {
        
        get {
            observed[keyPath: storageKeyPath].publisher.value
        }
        
        set {
            observed[keyPath: storageKeyPath].publisher.send(newValue)
            observed.objectWillChange.send()
        }
    }
}
