//
//  macOS_ExampleApp.swift
//  macOS-Example
//
//  Created by shayanbo on 2023/6/27.
//

import SwiftUI

@main
struct ExampleApp: App {
    @State private var window: NSWindow?

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 350, minHeight: 350)
                .background(WindowAccessor(window: $window))
                .onChange(of: window) { window in
                    window?.aspectRatio = NSSize(width: 1.0, height: 1.0) //TODO: pass AVLayer size here
                }
        }
        .windowResizability(.contentSize)
    }
}
