//
//  Amiibo+API.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 03/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Foundation

extension AmiiboAPI {
    // MARK: Response
    struct Response: Codable {
        var amiibo: [Model]
    }

    // MARK: Model
    struct Model: Codable {
        // MARK: Variables
        var amiiboSeries: String
        var character: String
        var gameSeries: String
        var head: String
        var image: String
        var name: String
        var release: ReleaseDateInfo?
        var tail: String
        var type: String

        // MARK: Methods
        func getID() -> String {
            return head+tail
        }
    }
}

// MARK: API Integration
extension Amiibo {
    convenience init(from model: AmiiboAPI.Model) {
        self.init(
            id: model.getID(),
            name: model.name,
            type: model.type,
            amiiboSeries: model.amiiboSeries,
            gameSeries: model.gameSeries,
            addToShelf: false
        )
    }

    func update(with newData: AmiiboAPI.Model) {
        id = newData.getID()
        name = newData.name
        type = newData.type
        amiiboSeries = newData.amiiboSeries
        gameSeries = newData.gameSeries

        if let newAmiiboRelease = newData.release {
            newAmiiboRelease.apply(to: self)
        }
    }
}
