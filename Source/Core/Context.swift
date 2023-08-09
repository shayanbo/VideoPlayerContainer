//
//  Context.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/22.
//

import Foundation

/// Context is the core concept, serving as a hub that's able to be accessed by all ``Service``s and ``Widget``s.
///
/// It maintains a service locator which developers can fetch other Service with it.
/// Developers are responsible for maintaing the Context instance and pass it to the ``PlayerWidget`` ( primary view in VideoPlayerContainer ).
/// Generally, the context lifecycle is the same as its enclosing underlying view.
///
public class Context : ObservableObject {
    
    public init() {}
    
    fileprivate let lock = NSRecursiveLock()
    
    fileprivate var services = [String: Service]()
    
    /// Obtain service instance by its Type.
    ///
    /// This method serves as a specialized service locator with a speicific cache policy, developers don't have to register before fetching.
    /// It accepts Service.Type as input and return a service instance as needed, making sure there's a maximum of one instance for each ``Service`` type in one Context instance.
    /// Also, you can stop it with ``stopService(_:)`` when you want.
    ///
    /// - Parameter type: Type of services. For example, DemoService.self.
    /// - Returns: the service instance corresponding to the type passed in.
    ///
    public func startService<ServiceType>(_ type:ServiceType.Type) -> ServiceType where ServiceType: Service {
        
        lock.lock()
        defer { lock.unlock() }
        
        let typeKey = String(describing: type)
        if let service = services[typeKey] {
            guard let service = service as? ServiceType else {
                fatalError()
            }
            return service
        } else {
            let service = type.init(self)
            services[typeKey] = service
            return service
        }
    }
    
    /// Stop Service when it's no longer needed
    ///
    /// Sometimes, we don't need to keep the service alive throughout the VideoPlayerContainer instance.
    /// For example, we have a Widget that uses a service which performs a **computation-intensive task** or has a **memory cache**.
    /// So, when this widget is no longer needed, you should call it to release the resources.
    ///
    @discardableResult public func stopService<ServiceType>(_ type:ServiceType.Type) -> Bool {
        
        lock.lock()
        defer { lock.unlock() }
        
        let typeKey = String(describing: type)
        if let _ = services[typeKey] {
            services[typeKey] = nil
            return true
        } else {
            return false
        }
    }
    
    /// Convenient API for ``startService(_:)``.
    public subscript<ServiceType>(_ type:ServiceType.Type) -> ServiceType where ServiceType: Service {
        startService(type)
    }
    
    private var dependencies = DependencyValues()
    
    /// Retrieve an external dependency of ``Service``.
    ///
    /// You can introduce external dependencies with ``Dependency`` propertyWrapper.
    /// In this way, you can easily change the implementation of Dependency to mock the return value of external dependencies
    ///
    /// - Parameter keyPath: The factory location for external dependency. See Also ``DependencyValues``.
    ///
    public func dependency<Value>(_ keyPath: KeyPath<DependencyValues, Value>) -> Value {
        dependencies.dependency(keyPath)
    }
    
    /// Replace the implementation of dependency to mock the return value of external dependencies.
    ///
    /// - Parameter keyPath: The factory location for external dependency. See Also ``DependencyValues``.
    /// - Parameter factory: The factory you wanna overwrite the original one.
    ///
    public func withDependency<Value>(_ keyPath: KeyPath<DependencyValues, Value>, factory: ()->Value) {
        dependencies.withDependency(keyPath, factory: factory)
    }
}
