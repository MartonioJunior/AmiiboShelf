//
//  FigureItemTableViewCell.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

class FigureItemTableViewCell: UITableViewCell, AmiiboDisplayProtocol {
    // MARK: Outlets
    @IBOutlet weak var amiiboImage: UIImageView!
    @IBOutlet weak var amiiboName: UILabel!
    @IBOutlet weak var amiiboSeries: UILabel!
    
    // MARK: Properties
    var amiibo: Amiibo? {
        didSet {
            self.amiiboImage.image = amiibo?.image
            self.amiiboName.text = amiibo?.name
            self.amiiboSeries.text = amiibo?.amiiboSeries
            guard let onShelf = amiibo?.onShelf else { return }

            self.backgroundColor = onShelf ? UIColor(red: 1, green: 184.0/255, blue: 51.0/255, alpha: 1) : .clear
        }
    }

    var sourceRect: CGRect {
        get {
            return self.frame
        }
    }
}
