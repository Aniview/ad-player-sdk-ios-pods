//
//  SingleAdViewModel.swift
//  ADPlayerBasicSample
//
//  Created by Pavel Yevtukhov on 25.09.2023.
//

import AdPlayerSDK
import Combine

final class SingleAdViewModel {
    private(set) var errorMessage = PassthroughSubject<String, Never>()

    private let publisherId: String
    private let tagId: String

    init(publisherId: String, tagId: String) {
        self.publisherId = publisherId
        self.tagId = tagId
    }

    func onViewReady() {
        initializeTag()
    }

    private func initializeTag() {
        let tag = AdPlayerTagConfiguration(tagId: tagId)
        let publisher = AdPlayerPublisherConfiguration(publisherId: publisherId, tag)
        AdPlayer.initializePublisher(publisher) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                break
            case .failure(let error):
                errorMessage.send("Failed to initialize publisher.  \(error.localizedDescription)")
            }
        }
    }
}
