//
//  AmiiboPreviewViewController.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 19/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

#warning("Clean up all of the old implementation for future compatibility work")
class AmiiboPreviewViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var amiiboImagePreview: UIImageView!
    @IBOutlet weak var amiiboNamePreview: UILabel!
    @IBOutlet weak var amiiboSeriesPreview: UILabel!
    @IBOutlet weak var returnButton: UIButton!

    // MARK: Variables
    var amiibo: Amiibo?

    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let amiibo = amiibo else { return }

        amiiboImagePreview.image = amiibo.getImage()
        amiiboNamePreview.text = amiibo.name
        amiiboSeriesPreview.text = amiibo.amiiboSeries+" series"

        returnButton.layer.cornerRadius = 3.0
        self.view.backgroundColor = amiibo.onShelf ? UIColor.secondary : UIColor.primary
    }

    @IBAction func returnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

#Preview {
    let controller = AmiiboPreviewViewController()
    return controller
}
