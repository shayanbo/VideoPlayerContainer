//
//  Dependency.swift
//  VideoPlayerContainer
//
//  Created by shayanbo on 2023/8/9.
//

import Foundation

/// A property wrapper you use to introduce external dependency into your ``Service``.
///
/// We prefer adopters to use this property wrapper to use external abilities. In this way, In the unit test, you can easily change its implementation by calling ``Context/withDependency(_:factory:)``.
///
/// For example: Let's say we have a http client fetching number from the remote server. and author a Service that provides a API which just calls the http client to fetch the number and return as the result of API.
/// ```swift
/// class TargetService: Service {
///
///     @Dependency(\.numberClient) var numberClient
///
///     func fetchData() async throws -> Int {
///         try await numberClient.fetch()
///     }
/// }
///
/// struct NumberClient {
///     var fetch: () async throws -> Int
/// }
///
/// extension DependencyValues {
///
///     var numberClient: NumberClient {
///         NumberClient {
///             let (data, _) = try await URLSession.shared.data(from: URL(string:"http://numbersapi.com/random/trivia")!)
///             let str = String(data: data, encoding: .utf8)
///             return Int(str?.components(separatedBy: " ").first ?? "") ?? 0
///         }
///     }
/// }
/// ```
/// Here, we use @Dependency to introduce the external dependency, and the implementation is the extension of DependencyValues. this object is kept inside ``Context``. so all of the dependencies' lifecycle is in line with the ``Context``.
/// Besides of Protocol, we can use struct/class with closure as properties to achieve IoC as well. like the NumberClient struct above.
///
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

/// Keep all of dependencies instance inside.
///
/// All of dependencies should be an read-only computed property extension of it.
/// The only instance of it is kept inside the ``Context``. See Also ``Dependency``.
///
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
