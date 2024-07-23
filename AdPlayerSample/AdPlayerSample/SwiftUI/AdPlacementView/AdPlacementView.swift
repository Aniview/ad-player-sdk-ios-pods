//
//  AdPlacementView.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 14.12.2023.
//

import AdPlayerSDK
import SwiftUI
import UIKit

struct AdPlacementView: View {
    private let animation: Animation?
    @StateObject private var viewModel: AdPlacementViewModel

    init(
        tagId: String,
        isFloatingEnabled: Bool = false,
        animation: Animation? = nil
    ) {
        self.animation = animation
        let viewModel = AdPlacementViewModel(
            tagId: tagId,
            enableFloating: isFloatingEnabled
        )
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        UIViewAdapter(adapted: viewModel.placementUiView)
            .frame(height: viewModel.playerHeight)
            .onAppear {
                viewModel.onAppear()
            }
            .onReceive(viewModel.animateSubject) {
                guard let animation = animation else {
                    viewModel.updateFrame()
                    return
                }
                withAnimation(animation) {
                    viewModel.updateFrame()
                }
            }
    }
}

private struct UIViewAdapter: UIViewRepresentable {
    typealias UIViewType = UIView

    let adapted: UIView

    func makeUIView(context: Context) -> UIView {
        adapted
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
