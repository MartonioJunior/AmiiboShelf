//
//  AmiiboExplorerView.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 03/10/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Foundation

// MARK: Requirements
protocol AmiiboExplorerView {
    associatedtype Subview: AmiiboView
}

// MARK: Default Implementation
extension AmiiboExplorerView {
    func check(_ amiibo: Amiibo, for searchString: String) -> Bool {
        amiibo.name.lowercased().localizedStandardContains(searchString) ||
        amiibo.amiiboSeries.lowercased().localizedStandardContains(searchString) ||
        amiibo.gameSeries.lowercased().localizedStandardContains(searchString)
    }

    func search(on collection: [Amiibo], with string: String) -> [Amiibo] {
        guard !string.isEmpty else { return collection }

        return collection.filter { check($0, for: string) }
    }

    func show(_ amiibo: Amiibo) -> Subview { Subview(amiibo) }
}
