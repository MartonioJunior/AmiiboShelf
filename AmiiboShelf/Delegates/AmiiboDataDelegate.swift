//
//  AmiiboDataDelegate.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 23/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import Foundation

protocol AmiiboDataDelegate {
    func imageDownloaded(for amiiboID: String)
    func new(amiibo: Amiibo)
    func amiiboDataUpdated()
}
