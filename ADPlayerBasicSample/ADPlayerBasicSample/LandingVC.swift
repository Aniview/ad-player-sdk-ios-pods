//
//  LandingVC.swift
//  ADPlayerBasicSample
//
//  Created by Pavel Yevtukhov on 25.09.2023.
//

import AdPlayerSDK
import UIKit

final class LandingVC: UIViewController {
    private let publisherId: String
    private let tagId: String

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

    private lazy var interstitialButton: UIButton = makeMenuButton(
        title: "Interstitial",
        action: #selector(onInterstitialTap)
    )

    private func makeMenuButton(
        title: String,
        action: Selector,
        titleColor: UIColor = .white,
        backGroundColor: UIColor = .gray
    ) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        var configuration = UIButton.Configuration.filled()
        button.setTitleColor(.white, for: .normal)
        configuration.baseBackgroundColor = .gray
        configuration.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        button.configuration = configuration
        return button
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        stackView.addArrangedSubview(singleAdButton)
        stackView.addArrangedSubview(interstitialButton)

        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        initializeTag()
    }

    @objc
    private func onSingleAdTap() {
        let viewController = SingleAdVC(tagId: tagId)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func onInterstitialTap() {
        let viewController = InterstitialExampleVC(tagId: tagId)
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func initializeTag() {
        stackView.isHidden = true
        let tag = AdPlayerTagConfiguration(tagId: tagId)
        let publisher = AdPlayerPublisherConfiguration(publisherId: publisherId, tag)
        isInProgress = true
        AdPlayer.initializePublisher(publisher) { [weak self] result in
            guard let self = self else { return }
            isInProgress = false
            switch result {
            case .success:
                stackView.isHidden = false
            case .failure(let error):
                showAlert(message: "Failed to initialize publisher.  \(error.localizedDescription)")
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
}
