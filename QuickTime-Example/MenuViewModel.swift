//
//  MenuViewModel.swift
//  test
//
//  Created by shayanbo on 2023/7/17.
//

import Foundation

class MenuViewModel: ObservableObject {
    
    @Published var isOpenFilePresented = false
    
    private init() {}
    
    static let shared = MenuViewModel()
}
