//
//  ToastWidget.swift
//  PlayerView
//
//  Created by shayanbo on 2023/6/15.
//

import SwiftUI

public class ToastService: Service {
    
    public struct Toast: Identifiable, Equatable {
        let title: String
        public let id = UUID().uuidString
        
        public static func == (a: Toast, b: Toast) -> Bool {
            return a.id == b.id
        }
    }
    
    @ViewState fileprivate var toasts = [Toast]()
    
    @ViewState fileprivate var verticalOffset = 48.0
    
    fileprivate var toastGetter: (Toast)->any View = { toast in
        Button(toast.title) {}
            .padding([.leading], 20)
            .buttonStyle(.borderedProminent)
    }
    
    public required init(_ context: Context) {
        super.init(context)
    }
    
    public func bindToastGetter(_ getter: @escaping (Toast)->any View) {
        toastGetter = getter
    }
    
    public func toast(_ toast: Toast) {
        withAnimation {
            toasts.append(toast)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [weak self] in
                withAnimation {
                    self?.toasts.removeAll { $0 == toast }
                }
            }
        }
    }
}

struct ToastWidget: View {
    
    var body: some View {
        
        WithService(ToastService.self) { service in
            ToastLayout(verticalOffset: service.verticalOffset) {
                ForEach(service.toasts) { toast in
                    AnyView(service.toastGetter(toast))
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
        }
    }
}

struct ToastLayout : Layout {
    
    let verticalOffset: CGFloat
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        
        var y = 0.0
        for subview in subviews.reversed() {
            let viewSize = subview.sizeThatFits(proposal)
            y = y + 8 + viewSize.height
            subview.place(at: CGPoint(x: 0, y: bounds.minY + (proposal.height ?? 0) - y), proposal: proposal)
        }
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        CGSize(width: proposal.width ?? 0, height: proposal.height ?? 0)
    }
}

