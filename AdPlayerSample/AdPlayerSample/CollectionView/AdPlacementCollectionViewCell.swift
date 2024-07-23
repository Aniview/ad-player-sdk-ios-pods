//
//  AdPlacementCollectionViewCell.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 19.07.2024.
//

import AdPlayerSDK
import UIKit

final class AdPlacementCollectionViewCell: UICollectionViewCell {
    var onHeightUpdate = {}
    var fittingWidth: CGFloat = 0
    private var placementHeight: CGFloat = 0
    private weak var adPlacement: UIView?
    private var tagId: String?

    func configure(tagId: String) {
        guard self.tagId != tagId else { return }

        self.tagId = tagId
        addAdPlacement(tagId: tagId)
    }

    private func addAdPlacement(tagId: String) {
        adPlacement?.removeFromSuperview()
        let placement = AdPlayerPlacementView(tagId: tagId)
        placement.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(placement)
        placement.bindConstraintsToContainer(insets: .init(top: 1, left: 0, bottom: 1, right: 0))
        self.adPlacement = placement
        placement.layoutDelegate = self

        contentView.layer.borderColor = UIColor.green.cgColor
        contentView.layer.borderWidth = 2
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)

        let height = placementHeight + 2
        layoutAttributes.frame.size = .init(width: fittingWidth, height: height)
        return layoutAttributes
    }
}

extension AdPlacementCollectionViewCell: AdPlacementLayoutDelegate {
    func adPlacementHeightWillChange(to newValue: CGFloat) {
        guard newValue != placementHeight else { return }

        placementHeight = newValue
        onHeightUpdate()
    }
}
