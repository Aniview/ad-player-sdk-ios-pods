//
//  LandingVC.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 25.09.2023.
//

import AdPlayerSDK
import UIKit
import class SwiftUI.UIHostingController

final class LandingVC: UIViewController {
    private let publisherId: String
    private let tagId: String
    private var playerTag: AdPlayerTag?

    init(publisherId: String, tagId: String) {
        self.publisherId = publisherId
        self.tagId = tagId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // not supposed to be used
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    private lazy var progressView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = .black
        return view
    }()

    private var isInProgress = false {
        didSet {
            if isInProgress {
                progressView.startAnimating()
            } else {
                progressView.stopAnimating()
            }
        }
    }

    private lazy var singleAdButton = makeMenuButton(
        title: "Single Ad",
        action: #selector(onSingleAdTap)
    )

    private lazy var tableViewButton = makeMenuButton(
        title: "Table View",
        action: #selector(onTableViewExampleTap)
    )

    private lazy var collectionViewButton = makeMenuButton(
        title: "Collection View",
        action: #selector(onCollectionViewExampleTap)
    )

    private lazy var interstitialButton = makeMenuButton(
        title: "Interstitial",
        action: #selector(onInterstitialExampleTap)
    )

    private lazy var swiftUIButton = makeMenuButton(
        title: "SwiftUI Basic",
        action: #selector(onSwiftUITap)
    )

    private lazy var preloadButton = makeMenuButton(
        title: "Preload",
        action: #selector(onPreloadTap),
        titleColor: .gray,
        backGroundColor: .systemBackground
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        initializeTag()
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        [
            singleAdButton,
            tableViewButton,
            collectionViewButton,
            interstitialButton,
            swiftUIButton,
            preloadButton
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc
    private func onSingleAdTap() {
        let viewController = SingleAdVC(tagId: tagId)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func onTableViewExampleTap() {
        let viewController = TableViewExampleVC(tagId: tagId)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func onCollectionViewExampleTap() {
        let viewController = CollectionViewExampleVC(tagId: tagId)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func onSwiftUITap() {
        let viewController = UIHostingController(rootView: BasicExample(tagId: tagId))
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func onInterstitialExampleTap() {
        let viewController = InterstitialExampleVC(publisherId: publisherId, tagId: tagId)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func onPreloadTap() {
        isInProgress = true
        playerTag?.preload { [weak self] _ in
            self?.isInProgress = false
        }
    }

    private func initializeTag() {
        let tagConfig = AdPlayerTagConfiguration(tagId: tagId)

        let publisher = AdPlayerPublisherConfiguration(publisherId: publisherId, tagConfig)
        isInProgress = true
        AdPlayer.initializePublisher(publisher) { [weak self] result in
            guard let self else { return }
            isInProgress = false
            switch result {
            case .success(let readyTags):
                playerTag = readyTags.first
            case .failure(let error):
                showAlert("Failed to initialize publisher.  \(error.localizedDescription)")
            }
        }
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }

    private func makeMenuButton(
        title: String,
        action: Selector,
        titleColor: UIColor = .white,
        backGroundColor: UIColor = .systemBlue
    ) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        var configuration = UIButton.Configuration.filled()
        button.setTitleColor(titleColor, for: .normal)
        configuration.baseBackgroundColor = backGroundColor
        configuration.contentInsets = .init(top: 10, leading: 40, bottom: 10, trailing: 40)
        button.configuration = configuration
        return button
    }
}
