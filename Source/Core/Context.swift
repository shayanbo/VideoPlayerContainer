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
    
    private let lock = NSRecursiveLock()
    
    private var services = [String: Service]()
    
    /// Obtain service instance by its Type.
    ///
    /// This method serves as a specialized service locator with a speicific cache policy, developers don't have to register before fetching.
    /// It accepts Service.Type as input and return a service instance as needed, making sure there's a maximum of one instance for each ``Service`` type in one Context instance.
    ///
    /// - Parameter type: Type of services. For example, DemoService.self.
    /// - Returns: the service instance corresponding to the type passed in.
    ///
    public func service<ServiceType>(_ type:ServiceType.Type) -> ServiceType where ServiceType: Service {
        
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
    
    /// Convenient API for ``service(_:)``.
    public subscript<ServiceType>(_ type:ServiceType.Type) -> ServiceType where ServiceType: Service {
        service(type)
    }
}
