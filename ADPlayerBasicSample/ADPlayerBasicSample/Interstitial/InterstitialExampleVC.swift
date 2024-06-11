//
//  InterstitialExampleVC.swift
//  AdPlayerQA
//
//  Created by Pavel Yevtukhov on 29.02.2024.
//

import UIKit
import AdPlayerSDK

final class InterstitialExampleVC: UIViewController {
    private let publisherId: String
    private let tagId: String
    private var playerTag: AdPlayerTag?
    private var inProgress = false {
        didSet {
            stackView.arrangedSubviews.forEach {
                if let control = $0 as? UIControl {
                    control.isEnabled = !inProgress
                }
            }
        }
    }

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemBlue
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var showButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Interstitial", for: .normal)
        button.addTarget(self, action: #selector(onShowButtonTap), for: .touchUpInside)
        return button
    }()

    init(publisherId: String, tagId: String) {
        self.publisherId = publisherId
        self.tagId = tagId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        stackView.addArrangedSubview(showButton)

        statusLabel.text = "Loading Tag..."

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])

        fetchPlayerTag()
    }

    private func fetchPlayerTag() {
        inProgress = true
        AdPlayer.getTagWhenReady(tagId: tagId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let playerTag):
                    self.playerTag = playerTag
                    inProgress = false
                    statusLabel.text = "Ready to load ADs"
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    @objc
    private func onShowButtonTap() {
        guard let playerTag = playerTag else { return }
        statusLabel.text = ""
        let interstitialBuilder = playerTag.asInterstitial()
        interstitialBuilder.launch()
    }
}
