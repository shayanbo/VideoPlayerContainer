//
//  Context.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/22.
//

import Foundation

/// Context is the core concept, serving as a hub that's able to be accessed by all ``Service`` and ``Widget``s
///
/// It maintains a service locator which developers can fetch other Service with it.
/// Developers are responsible for maintaing the Context instance and pass it to the ``PlayerWidget`` ( primary view in VideoPlayerContainer ).
/// Generally, the context lifecycle is the same as its enclosing underlying view
///
public class Context : ObservableObject {
    
    public init() {}
    
    private var services = [String: Service]()
    
    /// This method serves as a specialized service locator with a speicific cache policy, developers don't have to register before fetching.
    /// It accepts Service.Type as input and return a service instance as needed, making sure there's a maximum of one instance for each ``Service`` type in one Context instance
    /// 
    private func service<ServiceType>(_ type:ServiceType.Type) -> ServiceType where ServiceType: Service {
        
        let typeKey = String(describing: type)
        if let service = services[typeKey] {
            assert(service is ServiceType)
            return service as! ServiceType
        } else {
            let service = type.init(self)
            services[typeKey] = service
            return service
        }
    }
    
    public subscript<ServiceType>(_ type:ServiceType.Type) -> ServiceType where ServiceType: Service {
        service(type)
    }
}
