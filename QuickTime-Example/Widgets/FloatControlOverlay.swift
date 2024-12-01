//
//  FloatControlOverlay.swift
//  QuickTime-Example
//
//  Created by shayanbo on 2023/7/17.
//

import SwiftUI
import VideoPlayerContainer
import Combine

class FloatControlService : Service {
    
    @Published fileprivate var base = CGSize(width: 0, height: -50)
    @Published fileprivate var offset = CGSize(width: 0, height: -50)
    @Published fileprivate var opacity = 1.0
    
    @Published fileprivate var layer1: [IdentifableView]?
    @Published fileprivate var layer2: [IdentifableView]?
    
    public enum Location {
        case first
        case second
    }
    
    public func configure(_ location: Location, content: @escaping ()->[any View]) {
        let items = content().map { view in
            IdentifableView(id: UUID().uuidString) { view }
        }
        switch location {
        case .first:
            self.layer1 = items
        case .second:
            self.layer2 = items
        }
    }
    
    private var cancellables = [AnyCancellable]()
    
    required init(_ context: Context) {
        super.init(context)
        
        context.gesture.observe(.tap(.all)) { [weak self] _ in
            guard let self else { return }
            withAnimation {
                self.opacity = abs(self.opacity-1)
            }
        }.store(in: &cancellables)
        
        context.gesture.observe(.hover) { [weak self] event in
            guard let self else { return }
            self.opacity = event.action == .start ? 1 : 0
        }.store(in: &cancellables)
    }
}

struct FloatControlOverlay: View {
    
    var body: some View {
        GeometryReader { proxy in
            WithService(FloatControlService.self) { service in
                ZStack(alignment: .bottom) {
                    Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack(spacing: 10) {
                        HStack(spacing: 20) {
                            if let items = service.layer1 {
                                ForEach(items) { $0 }
                            }
                        }
                        HStack(spacing: 20) {
                            if let items = service.layer2 {
                                ForEach(items) { $0 }
                            }
                        }
                    }
                    .padding(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .frame(width: proxy.size.width < 450 ? proxy.size.width - 20 : 450)
                    .background(.thickMaterial)
                    .cornerRadius(10.0)
                    .offset(service.offset)
                    .opacity(service.opacity)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                service.offset.width = service.base.width + value.translation.width
                                service.offset.height = service.base.height + value.translation.height
                            }
                            .onEnded { value in
                                service.base = service.offset
                            }
                    )
                }
            }
        }
    }
}

extension Context {
    var floatControl: FloatControlService {
        self[FloatControlService.self]
    }
}
