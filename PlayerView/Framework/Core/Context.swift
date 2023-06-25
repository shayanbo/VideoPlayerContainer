//
//  Context.swift
//  PlayerView
//
//  Created by shayanbo on 2023/6/22.
//

import Foundation

public class Context : ObservableObject {
    
    private var services = [String: Service]()
    
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
