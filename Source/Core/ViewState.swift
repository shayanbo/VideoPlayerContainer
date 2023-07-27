//
//  Viewservice.swift
//  VideoPlayer
//
//  Created by shayanbo on 2023/6/22.
//

import Foundation
import Combine

/// ViewState is like @Published insides Observable.
/// 
/// we use @ViewState to modify the state in service. When the property changes, its enclosing ``Widget`` will update
/// Here's an example, demonstrating how the @ViewState make differences to its enclosing Widget
///
/// ```swift
/// class DemoService : Service {
///     @ViewState var hideOrShow = false
/// }
///
/// struct DemoWidget : Widget {
///     var body: some View {
///         WithService(DemoService.self) { service in
///             if service.hideOrShow {
///                 Text("Demo is showing")
///             } else {
///                 Image(systemName:"pencil")
///             }
///         }
///     }
/// }
/// ```
///
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
