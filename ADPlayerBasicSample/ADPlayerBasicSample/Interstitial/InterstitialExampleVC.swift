//
//  InterstitialExampleVC.swift
//  ADPlayerBasicSample
//
//  Created by Pavel Yevtukhov on 04.08.2023.
//

import AdPlayerSDK
import RxSwift
import UIKit

final class InterstitialExampleVC: UIViewController {
    private let tagId: String
    private let disposeBag = DisposeBag()
    private lazy var viewModel = InterstitialExampleViewModel(tagId: tagId)

    private lazy var progressView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = .black
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    private lazy var showButton = makeMenuButton(
        title: "Show Interstitial Ad",
        action: #selector(onShowInterstitialTap)
    )

    private lazy var preloadButton: UIButton = makeMenuButton(
        title: "Preload",
        action: #selector(onPreloadTap),
        titleColor: .gray,
        backGroundColor: .clear
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
        button.setTitleColor(titleColor, for: .normal)
        configuration.baseBackgroundColor = backGroundColor
        configuration.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        button.configuration = configuration
        return button
    }

    init(tagId: String) {
        self.tagId = tagId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // not supposed to be used
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        subscribeToViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        view.addSubview(progressView)
        stackView.addArrangedSubview(showButton)
        stackView.addArrangedSubview(preloadButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func subscribeToViewModel() {
        viewModel.isInProgressPublisher
            .observe(on: MainScheduler.instance)
            .subscribe { [unowned self] isInProgress in
            stackView.isUserInteractionEnabled = !isInProgress
            if isInProgress {
                progressView.startAnimating()
            } else {
                progressView.stopAnimating()
            }
        }.disposed(by: disposeBag)

        viewModel.errorMessagePublisher
            .observe(on: MainScheduler.instance)
            .subscribe { [unowned self] (message: String) in
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }.disposed(by: disposeBag)
    }

    @objc
    private func onPreloadTap() {
        viewModel.onPreload()
    }

    @objc
    private func onShowInterstitialTap() {
        viewModel.onShowInterstitial()
    }
}
