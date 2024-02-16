//
//  AdPlayerCell.swift
//  ADPlayerBasicSample
//
//  Created by Pavel Yevtukhov on 16.02.2024.
//

import AdPlayerSDK
import UIKit

final class AdCell: UITableViewCell {
    private weak var adPlaterVC: UIViewController?
    private var adSlot: AdSlot?

    func configure(adSlot: AdSlot, parentVC: UIViewController) {
        guard self.adSlot != adSlot else { return }

        self.adSlot = adSlot
        addAdPlacement(tagId: adSlot.tagId, parentVC: parentVC)
        
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

    private func addAdPlacement(tagId: String, parentVC: UIViewController) {
        removeAdPlayer()
        let placement = AdPlayerPlacementViewController(tagId: tagId)
        placement.view.translatesAutoresizingMaskIntoConstraints = false
        parentVC.addChild(placement)
        contentView.addSubview(placement.view)
        placement.view.bindConstraintsToContainer(insets: .init(top: 1, left: 0, bottom: 1, right: 0))
        placement.didMove(toParent: parentVC)
        self.adPlaterVC = placement
        contentView.layer.borderColor = UIColor.green.cgColor
        contentView.layer.borderWidth = 2
    }

    private func removeAdPlayer() {
        guard let adPlaterVC else { return }

        adPlaterVC.willMove(toParent: nil)
        adPlaterVC.view.removeFromSuperview()
        adPlaterVC.removeFromParent()
        self.adPlaterVC = nil
    }
}
