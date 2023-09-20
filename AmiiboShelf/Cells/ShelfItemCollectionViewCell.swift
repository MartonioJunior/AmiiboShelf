//
//  ShelfItemCollectionViewCell.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

class ShelfItemCollectionViewCell: UICollectionViewCell, AmiiboDisplayProtocol {
    // MARK: Outlets
    @IBOutlet weak var amiiboImage: UIImageView!

    // MARK: Properties
    var amiibo: Amiibo? {
        didSet {
            self.amiiboImage.image = amiibo?.image
        }
    }

    var sourceRect: CGRect {
        get {
            return self.frame
        }
    }
}
