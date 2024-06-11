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
    private var tagId: String?

    func configure(tagId: String) {
        guard self.tagId != tagId else { return }

        self.tagId = tagId
        addAdPlacement(tagId: tagId)
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
