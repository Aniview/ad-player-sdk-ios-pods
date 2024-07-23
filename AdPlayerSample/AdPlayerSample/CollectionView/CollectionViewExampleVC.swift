//
//  CollectionViewExampleVC.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 19.07.2024.
//

import AdPlayerSDK
import UIKit

enum Section: Int, CaseIterable {
    case textTop
    case adPlayer
    case boxes
    case textBottom
}

final class CollectionViewExampleVC: UIViewController {
    private let tagId: String

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize // enable self sizing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        return collectionView
    }()

    init(tagId: String) {
        self.tagId = tagId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(TextInfoColectionViewCell.self)
        collectionView.register(AdPlacementCollectionViewCell.self)
        collectionView.register(BoxColectionViewCell.self)

        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.bindConstraintsToContainerMargines()
    }
}

extension CollectionViewExampleVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        switch section {
        case .textTop: return 2
        case .adPlayer: return 1 // must be 1
        case .boxes: return 10
        case .textBottom: return 10
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }

        switch section {
        case .adPlayer:
            return makeAdCell(indexPath: indexPath)
        case .boxes:
            let cell: BoxColectionViewCell = collectionView.dequeue(for: indexPath)
            return cell
        case .textTop, .textBottom:
            let cell: TextInfoColectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(MockText.texts[indexPath.row % MockText.texts.count])
            cell.fittingWidth = collectionView.frame.width
            return cell
        }
    }

    private func makeAdCell(indexPath: IndexPath) -> UICollectionViewCell {
        let adCell: AdPlacementCollectionViewCell = collectionView.dequeue(for: indexPath)
        adCell.configure(tagId: tagId)
        adCell.onHeightUpdate = { [weak self] in
            guard let self else { return }

            // update layout with animation
            collectionView.performBatchUpdates({}, completion: nil)
        }
        adCell.fittingWidth = collectionView.frame.width

        return adCell
    }
}
