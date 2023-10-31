//
//  SingleAdVC.swift
//  ADPlayerBasicSample
//
//  Created by Pavel Yevtukhov on 25.09.2023.
//

import AdPlayerSDK
import RxSwift
import UIKit

final class SingleAdVC: UIViewController {
    private let tagId: String
    private lazy var viewModel = SingleAdViewModel(tagId: tagId)
    private var disposeBag = DisposeBag()
    private var adPlacementVC: UIViewController?

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

    private lazy var toggleAdButton = makeMenuButton(
        title: viewModel.toggleTitle,
        action: #selector(onToggleAdTap)
    )

    private lazy var preloadButton: UIButton = makeMenuButton(
        title: "Preload",
        action: #selector(onPreloadTap),
        titleColor: .gray,
        backGroundColor: .clear
    )

    private func addPlacement() {
        removeAdPlacement()
        let placement = AdPlayerPlacementViewController(tagId: tagId)
        placement.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(placement)
        view.addSubview(placement.view)
        NSLayoutConstraint.activate([
            placement.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placement.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placement.view.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        placement.didMove(toParent: self)
        self.adPlacementVC = placement
    }

    private func removeAdPlacement() {
        adPlacementVC?.willMove(toParent: nil)
        adPlacementVC?.view.removeFromSuperview()
        adPlacementVC?.removeFromParent()
        adPlacementVC = nil
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

        view.backgroundColor = .systemBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])

        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        stackView.addArrangedSubview(toggleAdButton)
        stackView.addArrangedSubview(preloadButton)

        subscribeToViewModel()
        viewModel.onViewReady()
    }

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

    private func subscribeToViewModel() {
        viewModel.isShowPlayerPublisher.subscribe { [unowned self] shouldShowPlayer in
            toggleAdButton.setTitle(viewModel.toggleTitle, for: .normal)

            if shouldShowPlayer {
                addPlacement()
            } else {
                removeAdPlacement()
            }
        }.disposed(by: disposeBag)

        viewModel.isInProgressPublisher.subscribe { [unowned self] isInProgress in
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
    private func onToggleAdTap() {
        viewModel.onAdToggle()
    }

    @objc
    private func onPreloadTap() {
        viewModel.onPreload()
    }
}
