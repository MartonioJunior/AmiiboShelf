//
//  CardItemCollectionViewCell.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

#warning("Clean up all of the old implementation for future compatibility work")
class CardItemCollectionViewCell: UICollectionViewCell {
    // MARK: Outlets
    @IBOutlet weak var amiiboImage: UIImageView!
    @IBOutlet weak var amiiboName: UILabel!

    // MARK: Properties
    var amiibo: Amiibo? {
        didSet {
            amiiboImage.image = amiibo?.fetchImage()
            amiiboName.text = amiibo?.name
            layer.cornerRadius = 6.0
            guard let onShelf = amiibo?.onShelf else { return }

            self.backgroundColor = onShelf ? .secondary : .clear
        }
    }
}

extension CardItemCollectionViewCell: AmiiboDisplayProtocol {}
