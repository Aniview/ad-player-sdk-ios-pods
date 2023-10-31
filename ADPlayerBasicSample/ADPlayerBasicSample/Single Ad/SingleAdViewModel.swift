//
//  SingleAdViewModel.swift
//  ADPlayerBasicSample
//
//  Created by Pavel Yevtukhov on 25.09.2023.
//

import AdPlayerSDK
import RxSwift

final class SingleAdViewModel {
    private(set) var toggleTitle: String = ""
    private(set) var isShowPlayerPublisher = PublishSubject<Bool>()
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

    private var isPlayerAdded: Bool = false {
        didSet {
            toggleTitle = isPlayerAdded ? "Reset": "Show"
            isShowPlayerPublisher.on(.next(isPlayerAdded))
        }
    }

    init(tagId: String) {
        self.tagId = tagId
    }

    func onViewReady() {
        isPlayerAdded = false
    }

    func onAdToggle() {
        isPlayerAdded.toggle()
    }

    func onPreload() {
        guard let playerTag = playerTag else {
            errorMessage = "Call 'AdPlayer.initializePublisher' first"
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
}
