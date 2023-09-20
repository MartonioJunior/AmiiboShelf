//
//  AmiiboDetailViewController.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

class AmiiboDetailViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var amiiboImage: UIImageView!
    @IBOutlet weak var amiiboName: UILabel!
    @IBOutlet weak var amiiboSeries: UILabel!
    @IBOutlet weak var amiiboGameSeries: UILabel!
    @IBOutlet weak var naLaunchDate: UILabel!
    @IBOutlet weak var euLaunchDate: UILabel!
    @IBOutlet weak var jpLaunchDate: UILabel!
    @IBOutlet weak var auLaunchDate: UILabel!
    @IBOutlet weak var shelfButton: UIButton!
    
    // MARK: Variables
    var amiibo: Amiibo?
    static var delegate: AmiiboShelfDelegate?
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let amiibo = amiibo else { return }
        
        amiiboImage.image = amiibo.image
        amiiboName.text = amiibo.name
        amiiboSeries.text = amiibo.amiiboSeries+" series"
        amiiboGameSeries.text = amiibo.gameSeries
    
        let releaseDates = ReleaseDates.from(amiibo)
        naLaunchDate.text = releaseDates.na
        euLaunchDate.text = releaseDates.eu
        jpLaunchDate.text = releaseDates.jp
        auLaunchDate.text = releaseDates.au

        shelfButton.layer.cornerRadius = 3.0
        updateStatus(onShelf: amiibo.onShelf)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard amiibo != nil else { return }

        AmiiboImageManager.reloadImage(from: &amiibo!)
        amiiboImage.image = amiibo!.image
    }
    
    // MARK: Methods
    @IBAction func returnButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func toggleItemOnShelf(_ sender: UIButton) {
        guard let amiibo = amiibo else { return }

        let coreData = CoreDataManager.current
        let isOnShelf = amiibo.onShelf
        let delegate = AmiiboDetailViewController.delegate

        if !isOnShelf, coreData.addedToShelf(amiibo: amiibo) {
            delegate?.addedToShelf(amiibo: amiibo)
            amiibo.onShelf = true
        } else if isOnShelf, coreData.removedFromShelf(amiibo: amiibo) {
            delegate?.removedFromShelf(amiibo: amiibo)
            amiibo.onShelf = false
        }

        updateStatus(onShelf: amiibo.onShelf)
    }
    
    func updateStatus(onShelf: Bool) {
        shelfButton.setTitle(!onShelf ? "Add to Shelf" : "Remove from Shelf", for: .normal)
        UIView.transition(with: self.view, duration: 0.5, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = onShelf ? UIColor(red: 1, green: 184.0/255, blue: 51.0/255, alpha: 1) : UIColor(red: 68.0/255, green: 135.0/255, blue: 117/255.0, alpha: 1)
        }, completion: nil)
    }
}
