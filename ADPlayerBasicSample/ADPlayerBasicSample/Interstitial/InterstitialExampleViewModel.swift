//
//  InterstitialExampleViewModel.swift
//  ADPlayerBasicSample
//
//  Created by Pavel Yevtukhov on 04.08.2023.
//

import AdPlayerSDK
import RxSwift

final class InterstitialExampleViewModel {
    private(set) var isInProgressPublisher = PublishSubject<Bool>()
    private(set) var errorMessagePublisher = PublishSubject<String>()
    private let tagId: String
    private lazy var playerTag = AdPlayer.getTagNowOrNil(tagId: tagId)

    private var isInProgress = false {
        didSet { isInProgressPublisher.on(.next(isInProgress)) }
    }

    private var errorMessage = "" {
        didSet { errorMessagePublisher.on(.next(errorMessage)) }
    }

    init(tagId: String) {
        self.tagId = tagId
    }

    func onPreload() {
        guard let playerTag = playerTag else {
            errorMessage = "Tag is not initialized"
            return
        }
        isInProgress = true
        playerTag.preload { [weak self] error in
            self?.isInProgress = false
            if let error = error {
                self?.errorMessagePublisher.on(.next(error.localizedDescription))
            }
        }
    }

    func onShowInterstitial() {
        guard let playerTag = playerTag else {
            errorMessage = "Tag is not initialized"
            return
        }
        let config = InterstitialConfiguration(noAdTimeoutSec: 10)
        playerTag.asInterstitial()
            .withConfiguration(config)
            .onDismissed {}
            .launch()
    }
}
