//
//  Amiibo.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit
import CoreData

class Amiibo {
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
    
    init(with: CDAmiibo) {
        self.id = with.amiiboID ?? "No ID"
        self.name = with.characterName ?? "No name"
        self.amiiboSeries = with.amiiboSeries ?? "No amiibo series"
        self.gameSeries = with.gameSeries ?? "No game series"
        self.auRelease = with.auReleaseDate
        self.euRelease = with.euReleaseDate
        self.jpRelease = with.jpReleaseDate
        self.naRelease = with.naReleaseDate
        self.imagePath = with.imageURL
        self.image = AmiiboImageManager.getImage(path: self.imagePath)
        self.onShelf = with.onShelf
        self.type = with.type ?? SearchType.figure.rawValue
    }
    
    static func from(cdAmiibos: [CDAmiibo]) -> [Amiibo] {
        var amiibos = [Amiibo]()
        for item in cdAmiibos {
            amiibos.append(Amiibo(with: item))
        }
        return amiibos
    }
}

struct ReleaseDates: Codable {
    var au: String?
    var eu: String?
    var jp: String?
    var na: String?
}

struct AmiiboAPIModel: Codable {
    var amiiboSeries: String
    var character: String
    var gameSeries: String
    var head: String
    var image: String
    var name: String
    var release: ReleaseDates?
    var tail: String
    var type: String
}
