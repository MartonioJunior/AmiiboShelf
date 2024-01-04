//
//  FigureItemTableViewCell.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

#warning("Clean up all of the old implementation for future compatibility work")
#warning("Check which features need to be brought to SwiftUI")
class FigureItemTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var amiiboImage: UIImageView!
    @IBOutlet weak var amiiboName: UILabel!
    @IBOutlet weak var amiiboSeries: UILabel!

    // MARK: Properties
    var amiibo: Amiibo? {
        didSet {
            amiiboImage.image = amiibo?.fetchImage()
            amiiboName.text = amiibo?.name
            amiiboSeries.text = amiibo?.amiiboSeries
            guard let onShelf = amiibo?.onShelf else { return }

            backgroundColor = onShelf ? .secondary : .clear
        }
    }
}

extension FigureItemTableViewCell: AmiiboDisplayProtocol {}
