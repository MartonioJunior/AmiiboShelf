//
//  Amiibo+API.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 03/09/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Foundation

// MARK: AmiiboAPIModel class
struct AmiiboAPIModel: Codable {
    // MARK: Variables
    var amiiboSeries: String
    var character: String
    var gameSeries: String
    var head: String
    var image: String
    var name: String
    var release: ReleaseDates?
    var tail: String
    var type: String
    
    // MARK: Methods
    func getID() -> String {
        return head+tail
    }
}

// MARK: AmiiboAPIStruct
struct AmiiboAPIStruct: Codable {
    var amiibo: [AmiiboAPIModel]
}

// MARK: ReleaseDates class
struct ReleaseDates: Codable {
    var au: String?
    var eu: String?
    var jp: String?
    var na: String?
}

extension ReleaseDates {
    func apply(to amiibo: CDAmiibo, format: String = "yyyy-mm-dd") {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        amiibo.auReleaseDate = formatter.date(from: au ?? "")
        amiibo.euReleaseDate = formatter.date(from: eu ?? "")
        amiibo.jpReleaseDate = formatter.date(from: jp ?? "")
        amiibo.naReleaseDate = formatter.date(from: na ?? "")
    }
    
    static func from(_ amiibo: Amiibo, format: String = "yyyy-mm-dd") -> ReleaseDates {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        let naLaunchDate = formatter.validate(releaseDate: amiibo.naRelease)
        let euLaunchDate = formatter.validate(releaseDate: amiibo.euRelease)
        let jpLaunchDate = formatter.validate(releaseDate: amiibo.jpRelease)
        let auLaunchDate = formatter.validate(releaseDate: amiibo.auRelease)
        return ReleaseDates(au: auLaunchDate, eu: euLaunchDate, jp: jpLaunchDate, na: naLaunchDate)
    }
}
