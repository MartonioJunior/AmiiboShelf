//
//  AmiiboShelfDelegate.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import Foundation

protocol AmiiboShelfDelegate {
    func addedToShelf(amiibo: Amiibo)
    func removedFromShelf(amiibo: Amiibo)
}
