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
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .blue
        return label
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
        statusLabel.text = "Loading Tag..."

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])

        showButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showButton)
        NSLayoutConstraint.activate([
            showButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        showButton.isEnabled = false
        AdPlayer.initializePublisher(publisherId: publisherId, tagId: tagId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let playerTag):
                self.playerTag = playerTag
                showButton.isEnabled = true
                statusLabel.text = "Ready to load ADs"
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    @objc
    private func onShowButtonTap() {
        guard let playerTag = playerTag else { return }

        statusLabel.text = "Preloading ..."
        playerTag.preload { [weak self] error in
            guard let self = self else { return }
            onStartLoadingAds(attempt: 0)
        }
    }

    private func onStartLoadingAds(attempt: Int) {
        guard let playerTag = playerTag else { return }
        guard attempt < 10 else {
            statusLabel.text = "No Ads"
            return
        }

        statusLabel.text = "Waiting for Ads ready. Attempt: \(attempt)..."
        playerTag.getReadyAdsCount { [weak self] count in
            guard let self = self else { return }

            if count > 0 {
                onAdsReady()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.onStartLoadingAds(attempt: attempt + 1)
                }
            }
        }
    }

    private func onAdsReady() {
        guard let playerTag = playerTag else { return }
        statusLabel.text = ""

        let interstitialBuilder = playerTag.asInterstitial()
        interstitialBuilder.launch()
    }
}
