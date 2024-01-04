//
//  ReleaseDateInfo.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 22/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Foundation

struct ReleaseDateInfo: Codable {
    // MARK: Constants
    static let dateFormat = "yyyy-mm-dd"

    // MARK: Variables
    var au: String?
    var eu: String?
    var jp: String?
    var na: String?
}

extension ReleaseDateInfo {
    func apply(to amiibo: CDAmiibo, format: String = dateFormat) {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        amiibo.auReleaseDate = formatter.date(from: au ?? "")
        amiibo.euReleaseDate = formatter.date(from: eu ?? "")
        amiibo.jpReleaseDate = formatter.date(from: jp ?? "")
        amiibo.naReleaseDate = formatter.date(from: na ?? "")
    }

    func apply(to amiibo: Amiibo, format: String = dateFormat) {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        amiibo.naRelease = formatter.date(from: na ?? "")
        amiibo.euRelease = formatter.date(from: eu ?? "")
        amiibo.jpRelease = formatter.date(from: jp ?? "")
        amiibo.auRelease = formatter.date(from: au ?? "")
    }

    static func from(_ amiibo: Amiibo, format: String = dateFormat) -> ReleaseDateInfo {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        let naLaunchDate = formatter.validate(releaseDate: amiibo.naRelease)
        let euLaunchDate = formatter.validate(releaseDate: amiibo.euRelease)
        let jpLaunchDate = formatter.validate(releaseDate: amiibo.jpRelease)
        let auLaunchDate = formatter.validate(releaseDate: amiibo.auRelease)
        return ReleaseDateInfo(au: auLaunchDate, eu: euLaunchDate, jp: jpLaunchDate, na: naLaunchDate)
    }
}
