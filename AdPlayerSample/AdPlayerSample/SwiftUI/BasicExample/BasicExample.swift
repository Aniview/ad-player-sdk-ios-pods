//
//  BasicExample.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 27.12.2023.
//

import SwiftUI

struct BasicExample: View {
    let tagId: String

    var body: some View {
        AdPlacementView(
            tagId: tagId,
            animation: .default
        )
        .padding(.vertical, 1)
        .border(.green, width: 1)
    }
}
