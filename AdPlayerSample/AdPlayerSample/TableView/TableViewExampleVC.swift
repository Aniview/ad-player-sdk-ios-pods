//
//  TableViewExampleVC.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 16.02.2024.
//

import AdPlayerSDK
import UIKit

final class TableViewExampleVC: UIViewController {
    private let tagId: String
    private var dataSource: TableViewDataSource?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1
        return tableView
    }()

    init( tagId: String) {
        self.tagId = tagId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.bindConstraintsToContainerMargines()
        fillDataSource()
    }

    private func fillDataSource() {
        let dataSource = TableViewDataSource(tableView: tableView)

        let textRows: [TableRow] = (4...20).map {
            let text = MockText.texts[$0 % MockText.texts.count]
            return .text(text)
        }
        var rows: [TableRow] = [
            .text(MockText.texts[0]),
            .adPlacement(tagId)
        ]
        rows.append(contentsOf: textRows)

        dataSource.setData(rows: rows)
        tableView.dataSource = dataSource
        self.dataSource = dataSource
    }
}
