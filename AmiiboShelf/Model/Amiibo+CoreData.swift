//
//  Amiibo+CoreData.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 13/10/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Foundation

extension Amiibo {
    // MARK: Initializers
    convenience init(with: CDAmiibo) {
        self.init(
            id: with.amiiboID ?? Placeholder.ID.rawValue,
            name: with.characterName ?? Placeholder.name.rawValue,
            type: with.type ?? SearchType.figure.rawValue,
            addToShelf: with.onShelf
        )

        self.amiiboSeries = with.amiiboSeries ?? Placeholder.amiiboSeries.rawValue
        self.gameSeries = with.gameSeries ?? Placeholder.gameSeries.rawValue
        self.auRelease = with.auReleaseDate
        self.euRelease = with.euReleaseDate
        self.jpRelease = with.jpReleaseDate
        self.naRelease = with.naReleaseDate

        set(imagePath: with.imageURL ?? "")
    }

    // MARK: Static Methods
    static func from(cdAmiibos: [CDAmiibo]) -> [Amiibo] {
        return cdAmiibos.map { Amiibo(with: $0) }
    }
}
