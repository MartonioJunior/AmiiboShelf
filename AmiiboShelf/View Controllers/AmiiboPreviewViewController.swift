//
//  AmiiboPreviewViewController.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 19/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

class AmiiboPreviewViewController: UIViewController {
    @IBOutlet weak var amiiboImagePreview: UIImageView!
    @IBOutlet weak var amiiboNamePreview: UILabel!
    @IBOutlet weak var amiiboSeriesPreview: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    
    var amiibo: Amiibo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let amiibo = amiibo else {
            return
        }
        amiiboImagePreview.image = amiibo.image
        amiiboNamePreview.text = amiibo.name
        amiiboSeriesPreview.text = amiibo.amiiboSeries+" series"
        returnButton.layer.cornerRadius = 3.0
        self.view.backgroundColor = amiibo.onShelf ? UIColor(red: 1, green: 184.0/255, blue: 51.0/255, alpha: 1) : UIColor(red: 68.0/255, green: 135.0/255, blue: 117/255.0, alpha: 1)
    }

    @IBAction func returnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
