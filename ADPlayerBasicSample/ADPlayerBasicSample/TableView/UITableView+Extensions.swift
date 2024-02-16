//
//  UITableView+Extensions.swift
//  ADPlayerBasicSample
//
//  Created by Pavel Yevtukhov on 16.02.2024.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>( _ type: T.Type, reuseIdentifier: String = T.defaultReuseIdentifier) {
        register(T.self, forCellReuseIdentifier: reuseIdentifier)
    }

    func dequeue<T: UITableViewCell>(withIdentifier identifier: String = T.defaultReuseIdentifier) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier) as? T else {
            fatalError("\(identifier) must be registered first")
        }
        return cell
    }
}

extension UITableViewCell {
    static var defaultReuseIdentifier: String { .init(describing: Self.self) }
}
