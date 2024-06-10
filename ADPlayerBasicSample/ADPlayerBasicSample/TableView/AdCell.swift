//
//  AdPlayerCell.swift
//  ADPlayerBasicSample
//
//  Created by Pavel Yevtukhov on 16.02.2024.
//

import AdPlayerSDK
import UIKit

final class AdCell: UITableViewCell {
    private weak var adPlacement: UIView?
    private var adSlot: AdSlot?

    func configure(adSlot: AdSlot) {
        guard self.adSlot != adSlot else { return }

        self.adSlot = adSlot
        addAdPlacement(tagId: adSlot.tagId)
        
        AdPlayer.initializePublisher(
            publisherId: adSlot.publisherId,
            tagId: adSlot.tagId
        ) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func addAdPlacement(tagId: String) {
        removeAdPlayer()
        let placement = AdPlayerPlacementView(tagId: tagId)
        placement.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(placement)
        placement.bindConstraintsToContainer(insets: .init(top: 1, left: 0, bottom: 1, right: 0))
        self.adPlacement = placement
        contentView.layer.borderColor = UIColor.green.cgColor
        contentView.layer.borderWidth = 2
    }

    private func removeAdPlayer() {
        adPlacement?.removeFromSuperview()
        self.adPlacement = nil
    }
}
