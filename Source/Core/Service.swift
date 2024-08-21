//
//  Service.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/22.
//

import Foundation
import SwiftUI
import Combine

/// Widget is actually the SwiftUI's View, it serves as a visible and interactive components inside the VideoPlayerContainer.
///
/// Commonly, most of Widget used inside VideoPlayerContainer will has its own Service and take the ``WithService`` as its root View to use the service
/// When you have to other service API, we encourage developers to use its own service as the bridge, instead of putting many WithService`s inside the Widget
///
public typealias Widget = View

/// The base class for other services, it keeps a reference to its context to make sure the custom service have access to other services.
///
/// Inside Service, we provides two useful propertyWrapper: @``ViewState``.
/// @ViewState is used to trigger the UI update mechanism, like @State.
///
///
/// There are two kinds of Service:
/// 1. **Widget Service**:
///     Widget Service is used by a specific Widget.
///     it's used as the ViewModel, handling all of the logic used by its Widget
///     it's also responsible for communicating with other Services, since sometimes the Widget needs to expose out some API used by other Widget
/// 2. **Non-Widget Service**:
///     Non-Widget Service is used by other Services. it's served as a public service,  exposing out API used by other services.
///
open class Service : ObservableObject {

    public weak var context: Context?
    
    public required init(_ context: Context) {
        self.context = context
    }
}

/// WithService is used as the root view inside Widgets.
///
/// It serves with two abilities:
/// 1. since one of the roles for Widget Service is ViewModel. therefore, taking it as the root view and call service's API to complete tasks of Widget.
/// 2. When the service's state changes, the Widget will trigger the UI update mechanism.
///
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
