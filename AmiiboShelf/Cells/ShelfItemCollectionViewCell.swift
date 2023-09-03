//
//  ShelfItemCollectionViewCell.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

class ShelfItemCollectionViewCell: UICollectionViewCell, AmiiboDisplayProtocol {
    @IBOutlet weak var amiiboImage: UIImageView!
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
