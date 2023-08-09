//
//  Dependency.swift
//  VideoPlayerContainer
//
//  Created by shayanbo on 2023/8/9.
//

import Foundation

@propertyWrapper
public struct Dependency<Value> {
    
    public var wrappedValue: Value {
        fatalError()
    }
    
    private let keyPath: KeyPath<DependencyValues, Value>
    
    public init(_ keyPath: KeyPath<DependencyValues, Value>) {
        self.keyPath = keyPath
    }
    
    public static subscript<OuterSelf: Service>(_enclosingInstance observed: OuterSelf, wrapped wrappedKeyPath: KeyPath<OuterSelf, Value>, storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>) -> Value {
        
        let keyPath = observed[keyPath: storageKeyPath].keyPath
        return observed.context.dependency(keyPath)
    }
}

public class DependencyValues {
    
    private var dependencies = [String: Any]()
    
    func dependency<Value>(_ keyPath: KeyPath<DependencyValues, Value>) -> Value {
        
        let typeKey = String(describing: Value.self)
        
        if dependencies[typeKey] == nil {
            dependencies[typeKey] = self[keyPath: keyPath]
        }
        
        guard let dep = dependencies[typeKey] as? Value else {
            fatalError()
        }
        return dep
    }
    
    func withDependency<Value>(_ keyPath: KeyPath<DependencyValues, Value>, factory: ()->Value) {
        
        let typeKey = String(describing: Value.self)
        dependencies[typeKey] = factory()
    }
}
