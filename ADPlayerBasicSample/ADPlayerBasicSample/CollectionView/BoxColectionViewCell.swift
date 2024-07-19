//
//  BoxColectionViewCell.swift
//  ADPlayerBasicSample
//
//  Created by Pavel Yevtukhov on 19.07.2024.
//

import UIKit

final class BoxColectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .lightGray

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 50),
            heightAnchor.constraint(equalToConstant: 50)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
