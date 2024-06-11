//
//  TableViewDataSource.swift
//  ADPlayerBasicSample
//
//  Created by Pavel Yevtukhov on 16.02.2024.
//

import UIKit

struct AdSlot: Equatable {
    let publisherId: String
    let tagId: String
}

enum TableRow {
    case text(_ text: String)
    case adPlacement(_ tagId: String)
}

final class TableViewDataSource: NSObject {
    init(
        tableView: UITableView
    ) {
        tableView.register(TextInfoCell.self)
        tableView.register(AdCell.self)
    }

    private var rows: [TableRow] = []

    func setData(rows: [TableRow]) {
        self.rows = rows
    }
}

extension TableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case .text(let text):
            let cell: TextInfoCell = tableView.dequeue()
            cell.configure(
                ArticleViewModel(
                    title: "Content row \(indexPath.row)",
                    text: text
                )
            )
            return cell
        case .adPlacement(let tagId):
            return makeAdCell(tableView, cellForRowAt: indexPath, tagId: tagId)
        }
    }

    private func makeAdCell(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath,
        tagId: String
    ) -> UITableViewCell {
        let cell: AdCell = tableView.dequeue()

        cell.configure(tagId: tagId)
        cell.separatorInset = .init(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude) // hide separator
        cell.selectionStyle = .none
        return cell
    }
}

