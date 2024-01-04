//
//  Amiibo.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit
import SwiftData
import Core

@Model final public class Amiibo {
    // MARK: Variables
    @Attribute(.unique) public var id: String
    var name: String
    var amiiboSeries: String
    var gameSeries: String
    var onShelf: Bool
    var type: String

    var auRelease: Date?
    var euRelease: Date?
    var jpRelease: Date?
    var naRelease: Date?
    var imagePath: String?

    // MARK: Constructors
    init(id: String, name: String, type: String, amiiboSeries: String? = nil, gameSeries: String? = nil,
         releaseData: ReleaseDateInfo? = nil, imagePath: String? = nil, addToShelf: Bool) {
        self.id = id
        self.name = name
        self.type = type
        self.amiiboSeries = amiiboSeries ?? Placeholder.amiiboSeries.rawValue
        self.gameSeries = gameSeries ?? Placeholder.gameSeries.rawValue
        self.onShelf = addToShelf

        releaseData?.apply(to: self)
        set(imagePath: imagePath ?? "")
    }

    // MARK: Methods
    func fetchImage(using api: AmiiboAPI = .current) -> UIImage {
        api.getImage(from: LocalEndpoint(imagePath ?? ""))
    }

    func set(imageURL: URL) {
        set(imagePath: imageURL.absoluteString)
    }

    func set(imagePath: String) {
        self.imagePath = imagePath
    }
}

// MARK: Identifiable
extension Amiibo: Identifiable {}
