//
//  AdPlacementView.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 14.12.2023.
//

import Foundation
import AdPlayerSDK
import Combine

final class AdPlacementViewModel: ObservableObject {
    let animateSubject = PassthroughSubject<Void, Never>()
    @Published var playerHeight: CGFloat = 0

    private(set) lazy var placementUiView: AdPlayerPlacementView  = {
        let placementView = AdPlayerPlacementView(tagId: tagId)
        placementView.setFloatingScope(autodetect: enableFloating)
        placementView.layoutDelegate = self
        return placementView
    }()

    private let tagId: String
    private let enableFloating: Bool

    init(
        tagId: String,
        enableFloating: Bool = false
    ) {
        self.tagId = tagId
        self.enableFloating = enableFloating
    }

    private var reportedPlayerHeight: CGFloat = 0

    func updateFrame() {
        playerHeight = reportedPlayerHeight
    }

    private var justAppearedTimer: Timer?

    func onAppear() {
        // expand view immediately without animation when it's just appeared
        justAppearedTimer?.invalidate()
        justAppearedTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            self?.justAppearedTimer?.invalidate()
            self?.justAppearedTimer = nil
        }
    }

    deinit {
        justAppearedTimer?.invalidate()
    }
}

extension AdPlacementViewModel: AdPlacementLayoutDelegate {
    func adPlacementContentDidAdd() {}

    func adPlacementHeightWillChange(to newValue: CGFloat) {
        guard reportedPlayerHeight != newValue else { return }
        reportedPlayerHeight = newValue
        if justAppearedTimer != nil && newValue > 0 { // no animation is needed when it's just appeared
            updateFrame()
        } else {
            animateSubject.send(())
        }
    }
}
