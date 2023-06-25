//
//  Service.swift
//  PlayerView
//
//  Created by shayanbo on 2023/6/22.
//

import Foundation
import SwiftUI
import Combine

public protocol Servable: AnyObject, ObservableObject {
    
    var context: Context { get }
    
    init(_ context: Context)
}

public class Service : Servable {

    public let context: Context
    
    public required init(_ context: Context) {
        self.context = context
    }
}

public struct WithService<Content, S> : View where Content: View, S: Service {
    
    @EnvironmentObject private var context: Context
    
    @ViewBuilder private let content: (S) -> Content
    
    private let serviceType: S.Type
    
    public init(_ serviceType: S.Type, @ViewBuilder content: @escaping (S) -> Content) {
        self.content = content
        self.serviceType = serviceType
    }
    
    public var body: some View {
        _WithService(state: context[serviceType]) {
            content($0)
        }
    }
    
    private struct _WithService : View {
        
        @ObservedObject var state: S
        
        @ViewBuilder let content: (S) -> Content
        
        var body: some View {
            content(state)
        }
    }
}
