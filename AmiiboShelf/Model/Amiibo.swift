//
//  Amiibo.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit
import CoreData

// TODO: Consider breaking up the data in the class into structures
class Amiibo {
    // MARK: Constants
    let missingID: String = "No ID"
    let missingName: String = "No name"
    let missingAmiiboSeries: String = "No amiibo series"
    let missingGameSeries: String = "No game series"

    // MARK: Variables
    var id: String
    var name: String
    var amiiboSeries: String
    var gameSeries: String
    var auRelease: Date?
    var euRelease: Date?
    var jpRelease: Date?
    var naRelease: Date?
    var imagePath: String?
    var image: UIImage
    var onShelf: Bool
    var type: String

    // #MARK: Constructors
    init(with: CDAmiibo) {
        self.id = with.amiiboID ?? missingID
        self.name = with.characterName ?? missingName
        self.amiiboSeries = with.amiiboSeries ?? missingAmiiboSeries
        self.gameSeries = with.gameSeries ?? missingGameSeries
        self.auRelease = with.auReleaseDate
        self.euRelease = with.euReleaseDate
        self.jpRelease = with.jpReleaseDate
        self.naRelease = with.naReleaseDate
        self.imagePath = with.imageURL
        self.image = Amiibo.getImage(path: self.imagePath)
        self.onShelf = with.onShelf
        self.type = with.type ?? SearchType.figure.rawValue
    }

    // MARK: Static Methods
    static func from(cdAmiibos: [CDAmiibo]) -> [Amiibo] {
        return cdAmiibos.map { Amiibo(with: $0) }
    }

    static func getImage(path: String?) -> UIImage {
        return AmiiboImageManager.getImage(path: path)
    }
}
