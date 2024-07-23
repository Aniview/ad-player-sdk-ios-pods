//
//  TextInfoColectionViewCell.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 19.07.2024.
//

import UIKit

final class TextInfoColectionViewCell: UICollectionViewCell {
    var fittingWidth: CGFloat = 0 {
        didSet {
            widthConstraint.constant = fittingWidth
        }
    }

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var widthConstraint: NSLayoutConstraint = {
        let constraint = contentLabel.widthAnchor.constraint(equalToConstant: 0)
        constraint.priority = .defaultHigh
        constraint.isActive = true
        return constraint
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(contentLabel)
        contentLabel.bindConstraintsToContainer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ text: String) {
        contentLabel.text = text
    }
}
