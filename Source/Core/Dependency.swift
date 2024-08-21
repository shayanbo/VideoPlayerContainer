//
//  Dependency.swift
//  VideoPlayerContainer
//
//  Created by shayanbo on 2023/8/9.
//

import Foundation

/// A property wrapper you use to introduce external dependency into your ``Service``.
///
/// We prefer adopters to use this property wrapper to use external abilities. In this way, In the unit test, you can easily replace its implementation by calling ``Context/withDependency(_:factory:)``.
///
/// For example: Let's say we have a http client fetching number from the remote server. and author a Service that provides a API which just calls the http client to fetch the number and return as the result of API.
/// ```swift
/// class TargetService: Service {
///
///     @Dependency(\.numberClient) var numberClient
///
///     @ViewState var data: Int?
///     @ViewState var error: Error?
///
///     func fetchData() async throws -> Int {
///         do {
///             self.data = try await numberClient.fetch()
///         } catch {
///             self.error = error
///         }
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
///
/// Here, we use @Dependency to introduce the external dependency, and the implementation is the extension of DependencyValues. this only instance of DependencyValues is kept inside ``Context``. so all of the dependencies' lifecycle is in line with the ``Context``.
/// Besides of Protocol, we can use struct/class with closure as properties to achieve IoC as well. like the NumberClient struct above.
///
/// When we are authoring **Unit Test**, we can easily replace the implementation of external dependency by using ``Context/withDependency(_:factory:)``
/// ```swift
/// func testFetchSuccess() async throws {
///
///     let context = Context()
///     let target = context[TargetService.self]
///
///     context.withDependency(\.numberClient) {
///         NumberClient { 10 }
///     }
///
///     try await target.fetchData()
///
///     XCTAssertNotNil(target.data)
///     XCTAssertNil(target.error)
///     XCTAssertEqual(target.data!, 10)
/// }
/// ```
///
/// - Important: With @``Dependency``, @``ViewState`` defined in the ``Service``, we can easily figure out how many external dependencies this Service depends on, how many State this Service maintains.
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
    
    public static subscript<OuterSelf: Service>(_enclosingInstance observed: OuterSelf, wrapped wrappedKeyPath: KeyPath<OuterSelf, Value>, storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>) -> Value? {
        
        let keyPath = observed[keyPath: storageKeyPath].keyPath
        return observed.context?.dependency(keyPath)
    }
}

/// Keep all of dependencies instance inside.
///
/// All of dependencies should be an read-only computed property extension of it.
/// The only instance of it is kept inside the ``Context``. See Also ``Dependency``.
///
public struct DependencyValues {
    
    private var dependencies = [String: Any]()
    
    private let lock = NSRecursiveLock()
    
    mutating func dependency<Value>(_ keyPath: KeyPath<DependencyValues, Value>) -> Value {
        
        lock.lock()
        defer { lock.unlock()}
        
        let typeKey = String(describing: Value.self)
        
        if dependencies[typeKey] == nil {
            dependencies[typeKey] = self[keyPath: keyPath]
        }
        
        guard let dep = dependencies[typeKey] as? Value else {
            fatalError()
        }
        return dep
    }
    
    mutating func withDependency<Value>(_ keyPath: KeyPath<DependencyValues, Value>, factory: ()->Value) {
        
        lock.lock()
        defer { lock.unlock()}
        
        let typeKey = String(describing: Value.self)
        dependencies[typeKey] = factory()
    }
}
