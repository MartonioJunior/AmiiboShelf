//
//  ShelfItemCollectionViewCell.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

class ShelfItemCollectionViewCell: UICollectionViewCell {
    // MARK: Outlets
    @IBOutlet weak var amiiboImage: UIImageView!

    // MARK: AmiiboDisplayProtocol
    var amiibo: Amiibo? {
        didSet {
            amiiboImage.image = amiibo?.fetchImage()
        }
    }
}

extension ShelfItemCollectionViewCell: AmiiboDisplayProtocol {}
