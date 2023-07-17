//
//  macOS_ExampleApp.swift
//  macOS-Example
//
//  Created by shayanbo on 2023/6/27.
//

import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 350, minHeight: 350)
        }
        .commands {
            Menu()
        }
    }
}

struct Menu : Commands {
    
    var body: some Commands {
        CommandGroup(after: .newItem) {
            Button("Open File ...") {
                MenuViewModel.shared.isOpenFilePresented.toggle()
            }.keyboardShortcut("o", modifiers: .command)
        }
    }
}
