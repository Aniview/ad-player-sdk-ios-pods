//
//  UICollectionView+Extensions.swift
//  ADPlayerBasicSample
//
//  Created by Pavel Yevtukhov on 19.07.2024.
//

import UIKit

extension UICollectionViewCell {
    static var defaultReuseIdentifier: String { .init(describing: Self.self) }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>( _ type: T.Type, reuseIdentifier: String = T.defaultReuseIdentifier) {
        register(type, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func dequeue<T: UICollectionViewCell>(
        withIdentifier identifier: String = T.defaultReuseIdentifier,
        for index: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: index) as? T else {
            fatalError("\(identifier) must be registered first")
        }
        return cell
    }
}
