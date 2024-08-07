//
//  SingleAdVC.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 25.09.2023.
//

import AdPlayerSDK
import UIKit

final class SingleAdVC: UIViewController {
    private let tagId: String

    init(tagId: String) {
        self.tagId = tagId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        addAdPlacement()
    }

    private func addAdPlacement() {
        let border = UIView()
        border.layer.borderColor = UIColor.blue.cgColor
        border.layer.borderWidth = 1
        border.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(border)
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            border.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        let placement = AdPlayerPlacementView(tagId: tagId)
        placement.translatesAutoresizingMaskIntoConstraints = false
        border.addSubview(placement)
        placement.bindConstraintsToContainer(insets: .init(top: 1, left: 1, bottom: 1, right: 1))
    }
}
